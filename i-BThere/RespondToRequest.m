//
//  RespondToRequest.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RespondToRequest.h"
#import "AppUtil.h"

@implementation RespondToRequest : NSObject

-(void) acceptRequestWithId: (NSString*) requestId{
    // create the url to the api using the request id provided
    NSString* url = [NSString stringWithFormat: @"http://ibthere.herokuapp.com/api/v1/requests/%@/accept", requestId];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void) rejectRequestWithId: (NSString*) requestId{
    // create the url to the api using the request id provided
    NSString* url = [NSString stringWithFormat: @"http://ibthere.herokuapp.com/api/v1/requests/%@/reject", requestId];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!"
                                                    message:@"Your friend should be on his way shortly!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[AppUtil alloc]init] displayAlertDialogWithTitle: @"An error occurred" andMessage: @"Could not send your response!"];

}

@end