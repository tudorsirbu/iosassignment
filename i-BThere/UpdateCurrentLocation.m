//
//  UpdateCurrentLocation.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateCurrentLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "AppUtil.h"

@implementation UpdateCurrentLocation : NSObject

/*
 * The method sends a POST request to the API server with 
 * the latest location where the user has been.
 */
-(void) updateMyCurrentLocationTo: (CLLocation*) location withFbId: (NSString*) facebookId andName: (NSString*) name{
    NSError *error;
    
    // create instance of the app util class
    AppUtil* util = [[AppUtil alloc] init];
    
    // prepare the data that needs to be posted
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys: facebookId, @"fb_id",
                          name, @"name",
                          [[NSNumber alloc] initWithDouble: location.coordinate.latitude], @"latitude",
                          [[NSNumber alloc] initWithDouble: location.coordinate.longitude], @"longitude",
                          [util getAppId], @"device_id",nil];
    
    // Create the request.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ibthere.herokuapp.com/api/v1/fb_users"]];
    
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

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[AppUtil alloc]init] displayAlertDialogWithTitle: @"An error occurred" andMessage: @"Could not update your location! Please check your Internet connection!"];

}

@end