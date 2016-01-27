//
//  ChildMyProfileViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/15/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChildMyProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ButtonLabel;
- (IBAction)ButtonFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *FollowUnfollowLabel;

@property (weak, nonatomic) IBOutlet UILabel *usernameHeadText;

@property BOOL followOrNot;
@property NSString* username;
@property NSArray* followers;
@property NSArray* followings;

@end
