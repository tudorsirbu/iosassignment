//
//  RequestMeetUp.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestMeetUp.h"
#import "AppUtil.h"

@implementation RequestMeetUp : NSObject


/*
 * The method sends a network request to the API to request a meet up 
 * with another app user.
 */
-(void) requestMeetUpWithFbId:(NSString *)receiver fromUserWithFbId: (NSString*) sender{
    NSError* error;
    
    // add the data that needs to be sent to the API to a dictionary
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: sender, @"sender",
                          receiver, @"receiver",
                          @"Request", @"message",nil];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ibthere.herokuapp.com/api/v1/requests"]];
    
    // Specify that it will be a POST request
    request.HTTPMethod = @"POST";
    
    // This is how we set header fields
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // set json data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:nil error: &error];
    
    // add the post data to the request
    [request setHTTPBody:jsonData];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[[AppUtil alloc]init] displayAlertDialogWithTitle: @"Request made successfully!" andMessage:@"Your friend will receive a notification soon!"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[AppUtil alloc]init] displayAlertDialogWithTitle: @"An error occurred" andMessage: @"Could not send your meet up request. Try again later!"];
}



@end
