//
//  FriendsListViewController.h
//  i-BThere
//
//  Created by Tudor Sirbu & Claudiu Tarta.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ViewControllerDelegate.h"
#import "User.h"

@interface SettingsViewController : UIViewController<UIImagePickerControllerDelegate>
// the share button
@property (strong) IBOutlet UIButton* share;

// the label where the user's name is displayed
@property (weak) IBOutlet UILabel* greeting;

@property (strong) User* model;
@property (weak) id <ViewControllerDelegate> delegate;


@end
