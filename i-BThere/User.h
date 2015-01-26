//
//  User.h
//  i-BThere
//
//   Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

// details about the user logged in the app
@property (strong) NSString* name;
@property (strong) NSString* facebookId;


-(id) initUserWith: (NSString* ) facebookId andName: (NSString*) name;
@end
