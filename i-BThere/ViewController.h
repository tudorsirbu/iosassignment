//
//  ViewController.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewControllerDelegate.h"
#import "User.h"

@interface ViewController : UIViewController<FBLoginViewDelegate, ViewControllerDelegate>
// the facebook login view
@property (weak, nonatomic) IBOutlet FBLoginView *loginButton;

// the user model which contains data about the currently logged in user
@property (strong) User* model;

@end
