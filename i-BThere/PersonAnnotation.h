//
//  PersonAnnotation.h
//  i-BThere
//
//  Created by Tudor Sirbu on 14/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PersonAnnotation : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
}

@property (strong) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
- (id)initWithLocation:(CLLocationCoordinate2D)coord andName: (NSString*) personName;

@end
