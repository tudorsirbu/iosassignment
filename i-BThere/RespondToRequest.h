//
//  RespondToRequest.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RespondToRequest : NSObject

// sends a network request to the API that the request has been rejected
-(void) rejectRequestWithId: (NSString*) requestId;
// sends a network request to the API that the request has been accepted
-(void) acceptRequestWithId: (NSString*) requestId;
@end
