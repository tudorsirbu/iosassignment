//
//  MapViewController.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "UpdateCurrentLocation.h"
#import "ViewControllerDelegate.h"

@interface MapViewController : UIViewController <UIAlertViewDelegate,GMSMapViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>
@property (strong) User* model;
@property (weak) id <ViewControllerDelegate> delegate;
@property (strong) UpdateCurrentLocation* updateCurrentLocationRequest;
@end
