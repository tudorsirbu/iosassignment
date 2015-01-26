//
//  AppUtil.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUtil.h"


@implementation AppUtil : NSObject 


/*
 * Returns the device token id which has been save previously in 
 * the data.plist file.
 */
-(NSString*) getAppId{
    // load the plist into a dictionary
    NSDictionary* dict = [self loadDataPlist];
    
    // return the device id from the plist
    return [dict objectForKey:@"deviceId"];
}

/*
 * Retrieves the facebook user's profile picture, adds it to a base 
 * marker image and returns the result as an UIImage
 */
-(UIImage*) generateUserMarkerForFacebookId: (NSString*) id{
    // create the url to the user's profile picture
    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", id];
    
    // load the base marker image
    UIImage* markerImage = [UIImage imageNamed:@"marker.png"];
    
    // load the user's profile picture
    UIImage* pic = [UIImage imageWithData: [NSData dataWithContentsOfURL:[NSURL URLWithString: userImageURL]]];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    CGSize size = CGSizeMake(60, 60);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    [markerImage drawInRect: CGRectMake(0, 0, 62, 62)];
    
    CGRect rect = CGRectMake(9.7,4.5, 43, 43);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:30.0] addClip];
    // Draw your image
    [pic drawInRect:rect];
    
    UIGraphicsPopContext();
    UIImage* output = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return output;
}

/*
 * The method displays an alert  view with a given title and message and a cancelation button
 */
- (void) displayAlertDialogWithTitle: (NSString*) title andMessage: (NSString*) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

-(NSMutableDictionary*) loadDataPlist{
    // get the path to the plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    // load the plist into a dictionary
    return [[NSMutableDictionary alloc] initWithContentsOfFile: path];
}
@end