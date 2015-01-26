//
//  UpdateCurrentLocation.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface UpdateCurrentLocation : NSObject

// sends a network request to the API with the net location of the current user
-(void) updateMyCurrentLocationTo: (CLLocation*) location withFbId: (NSString*) facebookId andName: (NSString*) name;
@end
