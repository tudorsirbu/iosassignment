//
//  MapViewController.m
//  i-BThere
//
//  Created by Tudor Sirbu on 13/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    // add an annotation to the map showing our current location
    self.map.showsUserLocation=YES;
}

@end
