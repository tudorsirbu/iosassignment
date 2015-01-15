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


@implementation MapViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    
    GMSMarker *myLocation;
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
//    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [locationManager requestWhenInUseAuthorization];
//    }
//
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
    }
    
    
    locationManager.delegate = self;
    
    //Configure Accuracy depending on your needs, default is kCLLocationAccuracyBest
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 100; // meters
    
    [locationManager startUpdatingLocation];
    
    mapView_.myLocationEnabled = YES;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude: locationManager.location.coordinate.longitude
                                                                 zoom:14];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView_;
    
    [self addMarker];
    [self getProfilePic];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSLog(@"Am intrat aici!");
    myLocation.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
}

-(void) addMarker{
    myLocation = [[GMSMarker alloc] init];
    myLocation.position = CLLocationCoordinate2DMake(41.887, -87.622);
    myLocation.appearAnimation = kGMSMarkerAnimationPop;
    myLocation.snippet = @"Tudor";
//    marker.icon = [UIImage imageNamed:@"flag_icon"];
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

-(void) getProfilePic{
    
}



@end
