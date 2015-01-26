//
//  User.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User : NSObject

-(id) initUserWith: (NSString* ) facebookId andName: (NSString*) name{
    self = [super init];
    if(self){
        _facebookId = facebookId;
        _name = name;
    }
    return self;
}

@end