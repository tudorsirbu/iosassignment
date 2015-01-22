//
//  AppUtil.m
//  i-BThere
//
//  Created by Tudor Sirbu on 22/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUtil.h"


@implementation AppUtil : NSObject 

-(NSString*) getAppId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile: path];
    
    NSLog(@"ID: %@", [dict objectForKey:@"deviceId"]);
    
    return [dict objectForKey:@"deviceId"];
}

-(void) sendServerUpdatedLocation{
    
}

@end