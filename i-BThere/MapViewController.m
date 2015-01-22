//
//  MapViewController.m
//  i-BThere
//
//  Created by Tudor Sirbu on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MapViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "AppUtil.h"


@implementation MapViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    GMSMarker *myLocation;
    NSData* receivedData;
    NSString* currentUserId;
    NSMutableDictionary* markerFriendsCorrelation;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    markerFriendsCorrelation = [[NSMutableDictionary alloc] init];
    
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];

#ifdef __IPHONE_8_0
    NSUInteger code = [CLLocationManager authorizationStatus];
    if (code == kCLAuthorizationStatusNotDetermined && ([self->locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self->locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
        // choose one request according to your business.
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            [self->locationManager requestAlwaysAuthorization];
        } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
            [self->locationManager  requestWhenInUseAuthorization];
        } else {
            NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
        }
    }
#endif
    
    locationManager.delegate = self;
    
    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 100; // meters
    
    [locationManager startUpdatingLocation];
    
    mapView_.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude: locationManager.location.coordinate.longitude
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    self.view = mapView_;
    
    [self addMarker];
    [self getFriends];
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        currentUserId = [FBuser objectID];
    }];
    
    
    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(getFriends)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    myLocation.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    [self updateMyCurrentLocation: location];
}

-(void) updateMyCurrentLocation: (CLLocation*) currentLocation{
    NSLog(@"Location updated!");
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://ibthere.herokuapp.com/api/v1/fb_users"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    // create instance of the app util class
    AppUtil* util = [[AppUtil alloc] init];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: currentUserId, @"fb_id",
                          [[NSNumber alloc] initWithDouble: currentLocation.coordinate.latitude], @"latitude",
                          [[NSNumber alloc] initWithDouble: currentLocation.coordinate.longitude], @"longitude",
                          [util getAppId], @"device_id",nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    
    [postDataTask resume];
}

-(void) addMarker{
    myLocation = [[GMSMarker alloc] init];
    myLocation.position = CLLocationCoordinate2DMake(41.887, -87.622);
    myLocation.appearAnimation = kGMSMarkerAnimationPop;
    myLocation.map = mapView_;
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
        
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", [FBuser objectID]];
            
            myLocation.snippet = [FBuser name];
            
            UIImage* pic = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: userImageURL]]];
            
            UIImage* markerImage = [UIImage imageNamed:@"marker.png"];
            
            // Begin a new image that will be the new image with the rounded corners
            // (here with the size of an UIImageView)
            CGSize size = CGSizeMake(60, 60);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIGraphicsPushContext(context);
            
            [markerImage drawInRect: CGRectMake(0, 0, 62, 62)];
            
            CGRect rect = CGRectMake(9.7,4.5, 43, 43);
            
            // Add a clip before drawing anything, in the shape of an rounded rect
            [[UIBezierPath bezierPathWithRoundedRect:rect
                                        cornerRadius:30.0] addClip];
            // Draw your image
            [pic drawInRect:rect];
            
            UIGraphicsPopContext();
            UIImage* output = UIGraphicsGetImageFromCurrentImageContext();
        
            
            // Get the image, here setting the UIImageView image
//            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext();
            
            myLocation.icon = output;
        }
    }];
}

- (void) getFriends{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        NSArray* friends = [result objectForKey:@"data"];
        for (NSDictionary<FBGraphUser>* friend in friends) {
//            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
//            [self addMarkerByFacebookId:friend.id andName: friend.name];
            [self getUserLocationByFacebookId: friend.id];
        }
    }];
}

-(void) addMarkerByFacebookId: (NSString *) id WithLatitude: (double) latitude andLongitude: (double) longitude{
    GMSMarker *userLocation = [[GMSMarker alloc] init];
    if([markerFriendsCorrelation objectForKey: id] != nil){
        userLocation = [markerFriendsCorrelation objectForKey: id];
    } else {
        [markerFriendsCorrelation setValue: userLocation forKey: id];
    }
    
    userLocation.position = CLLocationCoordinate2DMake(latitude, longitude);
    userLocation.appearAnimation = kGMSMarkerAnimationPop;
    userLocation.map = mapView_;
    
    [[FBRequest requestForGraphPath: id] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            NSLog(@"ERROR: %@", error);
        }
        
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", id];
            
//            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
//                userLocation.snippet  = [FBuser name];
//            }];
//
            userLocation.title = [FBuser name];
            userLocation.snippet = @"Click to arrange a meet up";
            userLocation.userData = id;
            
            UIImage* pic = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: userImageURL]]];
            
            UIImage* markerImage = [UIImage imageNamed:@"marker.png"];
            
            // Begin a new image that will be the new image with the rounded corners
            // (here with the size of an UIImageView)
            CGSize size = CGSizeMake(60, 60);
            UIGraphicsBeginImageContextWithOptions(size, NO, 0);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIGraphicsPushContext(context);
            
            [markerImage drawInRect: CGRectMake(0, 0, 62, 62)];
            
            CGRect rect = CGRectMake(9.7,4.5, 43, 43);
            
            // Add a clip before drawing anything, in the shape of an rounded rect
            [[UIBezierPath bezierPathWithRoundedRect:rect
                                        cornerRadius:30.0] addClip];
            // Draw your image
            [pic drawInRect:rect];
            
            UIGraphicsPopContext();
            UIImage* output = UIGraphicsGetImageFromCurrentImageContext();
            
            
            // Get the image, here setting the UIImageView image
            //            imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            // Lets forget about that we were drawing
            UIGraphicsEndImageContext();
            
            userLocation.icon = output;
        }
    }];
    
    
}

- (void) getUserLocationByFacebookId: (NSString*) id{
    NSString* url = [NSString stringWithFormat: @"http://ibthere.herokuapp.com/api/v1/fb_users/%@",id];
    NSURLRequest* request =  [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    
    // initiate the connection
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data {
    receivedData = data;
}

-  (void)connectionDidFinishLoading: (NSURLConnection *) connection {
    
    NSError* error;
    // create a dictionary from the JSON data
    NSDictionary *results = [NSJSONSerialization
                             JSONObjectWithData:receivedData
                             options:kNilOptions error:&error];
//    NSLog(@"dict: %@", results);
    
    if([results objectForKey: @"fb_id"] != nil){
        // get the latitude & longitude from the dictionary as double
        
        NSString* fb_id = [results objectForKey: @"fb_id"];
        
        [self addMarkerByFacebookId:fb_id WithLatitude: [[results objectForKey: @"latitude"] doubleValue]
                       andLongitude:[[results objectForKey: @"longitude"] doubleValue]];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"They will receive a notification regarding your request."
                                                   delegate:nil
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    
    [[FBRequest requestForGraphPath: marker.userData] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        NSString* title = [NSString stringWithFormat: @"Would you like to meet with %@?", [FBuser name]];
        [alert setTitle: title];
        [alert show];
    }];
}

@end
