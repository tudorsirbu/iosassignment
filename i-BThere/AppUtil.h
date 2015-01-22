//
//  AppUtil.h
//  i-BThere
//
//  Created by Tudor Sirbu on 22/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject
-(NSString*) getAppId;
-(void) sendServerUpdatedLocation;
@end