//
//  MyProfileTableViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/15/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildMyProfileViewController.h"


@interface MyProfileTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIView *topViewContainer;

@property NSString* username;

@property NSMutableArray* posts;
@end
