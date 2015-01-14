//
//  MapViewController.m
//  i-BThere
//
//  Created by Tudor Sirbu on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MapViewController.h"
#import "PersonAnnotation.h"
#import <FacebookSDK/FacebookSDK.h>


@implementation MapViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    // add an annotation to the map showing our current location
    self.map.showsUserLocation=YES;
    
    [self addAnnotation];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Annotation";
    // like we saw with table cells - see if there is an annotation view that we can reuse
    // if there is, use it
    // of not, make one
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    } else {
        annotationView.annotation = annotation;
    }
    // set the properties of the annotation view
    // including a custom photo marker
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }
        
        else {
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [FBuser objectID]];
            
            UIImage* pic = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: userImageURL]]];
            
            
            annotationView.image = pic;
        }
    }];
    
    return annotationView;
}

//-(UIImage*) getUserProfilePic{
//    UIImage *image = nil;
//    
//    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
//        if (error) {
//            // Handle error
//        }
//        
//        else {
//            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small", [FBuser objectID]];
//            
//            UIImage* pic = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: userImageURL]]];
//            
//        }
//    }];s
//    
//    return image;
//}

-(void) addAnnotation{
    CLLocationCoordinate2D coord = self.map.centerCoordinate;
    PersonAnnotation *annotation = [[PersonAnnotation alloc] initWithLocation:coord andName: @"Tudor"];

    [self.map addAnnotation: annotation];
}


@end
