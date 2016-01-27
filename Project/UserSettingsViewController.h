//
//  UserSettingsViewController.h
//  Project
//
//  Created by tomer aronovsky on 12/30/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface UserSettingsViewController : UIViewController

@property NSString* current_username;


- (IBAction)logout:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *changeEmail;
@property (weak, nonatomic) IBOutlet UITextField *changePass;
- (IBAction)saveUserSettings:(id)sender;

@end
