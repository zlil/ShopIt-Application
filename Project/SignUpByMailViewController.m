//
//  SignUpByMailViewController.m
//  Project
//
//  Created by tomer aronovsky on 12/23/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "SignUpByMailViewController.h"
#import <Parse/Parse.h>
@interface SignUpByMailViewController ()

@end

@implementation SignUpByMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    
    [self.signUpButton.layer setBorderWidth:2.0];
    [self.signUpButton.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    
    UIColor *color = [UIColor blackColor];
    self.passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Select Password.." attributes:@{NSForegroundColorAttributeName: color}];
    self.UsernameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Select Username.." attributes:@{NSForegroundColorAttributeName: color}];
    self.EmailInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Enter your Email.." attributes:@{NSForegroundColorAttributeName: color}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
}
*/

- (IBAction)SignUpButton:(id)sender {
    [[Model instance] createNewUser:self.UsernameInput.text password:self.passwordInput.text email:self.EmailInput.text block:^(BOOL res) {
        if(res){
            [self performSegueWithIdentifier:@"SignUpLoginSuccess" sender:self];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops.."
                                                                           message:@"Your sign up details is incorrect."
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
}];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
@end
