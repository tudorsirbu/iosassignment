//
//  PersonAnnotation.m
//  i-BThere
//
//  Created by Tudor Sirbu on 14/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "PersonAnnotation.h"

@implementation PersonAnnotation
@synthesize coordinate;
@synthesize name;

- (id)initWithLocation:(CLLocationCoordinate2D)coord andName: (NSString*) personName {
    self = [super init];
    if (self) {
        coordinate = coord;
        name = personName;
    }
    return self;
}

-(NSString*) title{
    return self.name;
}
@end
