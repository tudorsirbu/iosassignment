//
//  MapViewController.h
//  i-BThere
//
//  Created by Tudor Sirbu on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak) IBOutlet MKMapView *map;
@end
