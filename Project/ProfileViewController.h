//
//  ProfileViewController.h
//  Project
//
//  Created by tomer aronovsky on 12/30/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"


@interface ProfileViewController : UIViewController{
    NSMutableArray* posts;
    NSArray* followers;
    NSArray* followings;
    IBOutlet UITableView* profileTableView;
}
@property NSString* username;
@property BOOL followOrNot;

@property (weak, nonatomic) IBOutlet UILabel *followersNumber;
@property (weak, nonatomic) IBOutlet UILabel *postsNumber;
@property (weak, nonatomic) IBOutlet UILabel *followingsNumber;

- (IBAction)FollowUnFollowButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *FollowUnfollowLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameHeadLabel;

@property NSInteger number;

@end
