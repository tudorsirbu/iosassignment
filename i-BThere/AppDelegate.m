//
//  AppDelegate.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RespondToRequest.h"

@implementation AppDelegate{
    NSString* meetupRequestId;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialize the facebook sdk
    [FBLoginView class];
    
    //register for push notifications
#ifdef __IPHONE_8_0
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // use registerUserNotificationSettings
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    } else {
        // use registerForRemoteNotifications
        [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
#else
    // use registerForRemoteNotifications
    [application registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
#endif
    
    // set the API for Google Maps API
    [GMSServices provideAPIKey:@"AIzaSyBlNJ28KdpELu-IgPYAIkeFAsdnkWY1HOY"];
    
    // check if the app became active because the user opened a notification
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(remoteNotif){
        [self displayAlertViewWithInfo: remoteNotif];
    }
        
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
        sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    return wasHandled;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // process the device token to remove spaces and angular brakets
    NSString* device =  [NSString stringWithFormat:@"%@", deviceToken];
    device = [device  stringByReplacingOccurrencesOfString:@" " withString:@""];
    device = [device  stringByReplacingOccurrencesOfString:@"<" withString:@""];
    device = [device  stringByReplacingOccurrencesOfString:@">" withString:@""];

    // save the device id into a dictionary
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue: device forKey: @"deviceId"];
    
    NSError *error;
    
    // get the path to the plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    // write the dictionary to the plist
    [data writeToFile: path atomically:YES];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // the application received a notification, display it to the user
    [self displayAlertViewWithInfo: userInfo];
}

- (void) displayAlertViewWithInfo: (NSDictionary*) userInfo{
    // get the alert message
    NSString* alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    // check what notification it is
    if(![userInfo objectForKey: @"type"]){
        // create an alert dialog
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New meet-up"
                                                    message: alert
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Accept", nil];
        // display the alert dialog
        [alertView show];
    
        // set the request id
        meetupRequestId = [userInfo objectForKey:@"request_id"];
    } else {
        // create an alert dialog
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Response to your request"
                                                            message: alert
                                                           delegate: nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // check  if the accept button has been pressed
    if(buttonIndex == 1){
        NSLog(@"Request %@ accepted", meetupRequestId);
        [[[RespondToRequest alloc] init] acceptRequestWithId: meetupRequestId];
    } else {
        NSLog(@"Request %@ rejected", meetupRequestId);
        [[[RespondToRequest alloc] init] rejectRequestWithId: meetupRequestId];

    }
}



@end
