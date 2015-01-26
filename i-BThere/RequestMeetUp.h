//
//  RequestMeetUp.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestMeetUp : NSObject<NSURLConnectionDelegate>

// sends a request for a meetup 
-(void) requestMeetUpWithFbId:(NSString *)receiver fromUserWithFbId: (NSString*) sender;
@end
