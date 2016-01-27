//
//  LoginViewController.h
//  Project
//
//  Created by tomer aronovsky on 12/23/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
- (IBAction)signIn:(id)sender;




@property (weak, nonatomic) IBOutlet UILabel *shopitLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInLabel;

@end
