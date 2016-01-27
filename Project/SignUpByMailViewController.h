//
//  SignUpByMailViewController.h
//  Project
//
//  Created by tomer aronovsky on 12/23/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Model.h"
#import "LoginViewController.h"


@interface SignUpByMailViewController : UIViewController
- (IBAction)SignUpButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *UsernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *EmailInput;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
