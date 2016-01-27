//
//  LoginViewController.m
//  Project
//
//  Created by tomer aronovsky on 12/23/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Model.h"



@interface LoginViewController ()

@end


@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
     */
    
    // --- custom design for background, lables, textfields, etc .. ---- //
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.signInLabel.layer setBorderWidth:2.0];
    [self.signInLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    UIFont *font = [UIFont fontWithName:@"Miss Issippi Demo" size:36];
    [self.shopitLabel setFont:font];
    [self.shopitLabel setTextColor:[UIColor whiteColor]];
    UIColor *color = [UIColor blackColor];
    self.passwordInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Enter Password.." attributes:@{NSForegroundColorAttributeName: color}];
    self.usernameInput.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Enter Username.." attributes:@{NSForegroundColorAttributeName: color}];


}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([Model instance].current_username != nil) {
         [self performSegueWithIdentifier:@"SuccesfullLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   
}*/

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

//main screen - login function
- (IBAction)signIn:(id)sender {
    [[Model instance]loginUser:self.usernameInput.text password:self.passwordInput.text block:^(BOOL res) {
        if(res){
            [self performSegueWithIdentifier:@"SuccesfullLogin" sender:self];
        }
        else
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops.."
                                                                           message:@"Your login details is incorrect."
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}






@end
