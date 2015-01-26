//
//  AppUtil.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject
/*
 * Returns the device token id which has been save previously in
 * the data.plist file.
 */
-(NSString*) getAppId;

// retrieves the user's facebook profile picture and adds it to a marker
-(UIImage*) generateUserMarkerForFacebookId: (NSString*) id;

// displays an alert view with the given title and message
- (void) displayAlertDialogWithTitle: (NSString*) title andMessage: (NSString*) message;

@end