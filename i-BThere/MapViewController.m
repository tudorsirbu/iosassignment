//
//  MapViewController.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MapViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "AppUtil.h"
#import "AppDelegate.h"
#import "RequestMeetUp.h"


@implementation MapViewController{
    GMSMapView *mapView;
    CLLocationManager *locationManager;
    GMSMarker *myLocation;
    NSData* receivedData;
    NSString* lastUserSelected;
    NSMutableDictionary* markerFriendsCorrelation;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    // create instance of the class that updates the current location on the server
    self.updateCurrentLocationRequest = [[UpdateCurrentLocation alloc] init];
    
    // initialize the dictionary where the friends and their markers will be stored
    markerFriendsCorrelation = [[NSMutableDictionary alloc] init];
    
    // initialize the location manager
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    // request location permissions
    [self requestLocationPermissions];
    
    // set this view controller as a delegate for the location manager
    locationManager.delegate = self;

    // configure accuracy
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;

    // set a movement threshold for new events.
    locationManager.distanceFilter = 100; // meters
    
    // set where the camera will be positioned on the map
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude: locationManager.location.coordinate.longitude
                                                                 zoom:14];
    
    // create the map
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // set the current view controller as the map's delegate
    mapView.delegate = self;
    
    // display the map
    self.view = mapView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // add the marker representing the location of this user
    [self addMyMarker];
    
    // start receiving location updates
    [locationManager startUpdatingLocation];
    
    [self getFriends];
    
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
    // get the last known location
    CLLocation* location = [locations lastObject];
    
    // update the location of the marker that represents the current user
    myLocation.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    
    // send the updated location to the server
    [self.updateCurrentLocationRequest updateMyCurrentLocationTo:location withFbId: self.model.facebookId andName:self.model.name];
}

-(void) addMyMarker{
    myLocation = [[GMSMarker alloc] init];
    myLocation.position = CLLocationCoordinate2DMake(41.887, -87.622);
    myLocation.appearAnimation = kGMSMarkerAnimationPop;
    myLocation.snippet = self.model.name;
    
    myLocation.icon = [[[AppUtil alloc] init] generateUserMarkerForFacebookId: self.model.facebookId];
    myLocation.map = mapView;
}

- (void) getFriends{
    dispatch_queue_t downloadQueue = dispatch_queue_create("GetFacebookFriends", NULL);
    
    dispatch_async(downloadQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            FBRequest* friendsRequest = [FBRequest requestForMyFriends];
            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                          NSDictionary* result,
                                                          NSError *error) {
                NSArray* friends = [result objectForKey:@"data"];
                for (NSDictionary<FBGraphUser>* friend in friends) {
                    [self getUserLocationByFacebookId: [friend objectID]];
                }
            }];
        });
    });
}

-(void) addMarkerByFacebookId: (NSString *) id forUserWithName: (NSString*) name andWithLatitude: (double) latitude andLongitude: (double) longitude{
    GMSMarker *userLocation = [[GMSMarker alloc] init];
    if([markerFriendsCorrelation objectForKey: id] != nil){
        userLocation = [markerFriendsCorrelation objectForKey: id];
    } else {
        [markerFriendsCorrelation setValue: userLocation forKey: id];
    }
    
    userLocation.position = CLLocationCoordinate2DMake(latitude, longitude);
    userLocation.appearAnimation = kGMSMarkerAnimationPop;
    userLocation.title = name;
    userLocation.snippet = @"Click to arrange a meet up";
    userLocation.userData = id;
    
    userLocation.icon = [[[AppUtil alloc] init] generateUserMarkerForFacebookId: id];
    userLocation.map = mapView;
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
    
    if([results objectForKey: @"fb_id"] != nil){
        // get the user's facebook id
        NSString* fb_id = [results objectForKey: @"fb_id"];
        NSString* name = [results objectForKey: @"name"];
        
        [self addMarkerByFacebookId: fb_id
                    forUserWithName:name
                    andWithLatitude:[[results objectForKey: @"latitude"] doubleValue]
                       andLongitude:[[results objectForKey: @"longitude"] doubleValue]];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    // ignore taps on the current user's marker info window
    if(!marker.userData){
        // go to the next view
        [self.delegate dismissMap];
        return;
    }
    
    // create and prepare an alert dialog that asks the user to confirm they want to send a request
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"They will receive a notification regarding your request."
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    
    // set the last selected user to the one in the current marker
    lastUserSelected = marker.userData;
    
    // query facebook to get the user's name and show the alert
    [[FBRequest requestForGraphPath: marker.userData] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        NSString* title = [NSString stringWithFormat: @"Would you like to meet with %@?", [FBuser name]];
        [alert setTitle: title];
        [alert show];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // check  if the yess button has been pressed
    if(buttonIndex == 1){
        // instantiate the meet up request class
        RequestMeetUp* request = [[RequestMeetUp alloc] init];
        // send a request to the selected user from the current user
        [request requestMeetUpWithFbId: lastUserSelected fromUserWithFbId: self.model.facebookId];
    }
}

-(void) requestLocationPermissions{
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
}

@end
