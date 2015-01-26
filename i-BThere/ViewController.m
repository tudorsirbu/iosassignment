//
//  ViewController.m
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "MapViewController.h"
#import "AppUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	
    // request necessary permissions from Facebook
    self.loginButton.readPermissions = @[@"public_profile", @"user_friends"];
}

/*
 * The method initializes the user model with the details of the currently 
 * logged in user.
 */
-(void) initializeModel{
    // create a new model instance
    self.model = [[User alloc] init];
    
    // get the logged in user details
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        self.model.name = [FBuser name];
        self.model.facebookId = [FBuser objectID];
    }];
}

/*
 * The method prepares the segue and passes any
 * necessary information to the next controller.
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier]isEqualToString:@"goToFriendsList"]) {
        SettingsViewController *controller = [segue destinationViewController];
        controller.model = self.model;
        controller.delegate = self;
    } else if([[segue identifier]isEqualToString:@"goToMap"]){
        MapViewController *controller = [segue destinationViewController];
        controller.model = self.model;
        controller.delegate = self;
    }
}

/*
 * The method dismisses the current modal and
 * opens a new one containing the settings
 */
-(void) dismissMap{
    // dismiss the current modal
    [self dismissViewControllerAnimated:YES completion:^{
        // start a new modal with the map view controller
        [self performSegueWithIdentifier: @"goToFriendsList" sender:self];
    }];
}

/*
 * The method dismisses the current modal and
 * opens a new one containing the map
 */

-(void) dismissSettings{
    // dismiss the current modal
    [self dismissViewControllerAnimated:YES completion:^{
        // start a new modal with the map view controller
        [self performSegueWithIdentifier: @"goToMap" sender:self];
    }];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * The method is called when the user logs in or if the user
 * is logged in and it takes the user to the next view.
 */
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // initalize the model
    [self initializeModel];
    
    // go to the next view
    [self performSegueWithIdentifier:@"goToMap" sender:self];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // dismiss the current modal
    [self dismissViewControllerAnimated:YES completion: nil];
}


// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
