//
//  ForgotPasswordViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/10/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
- (IBAction)forgotPasswordButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailLabel;

@end
