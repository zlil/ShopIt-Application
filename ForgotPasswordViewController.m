//
//  ForgotPasswordViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/10/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Model.h"


@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // --- custom design for background ---- //
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [self.forgotPasswordLabel.layer setBorderWidth:2.0];
    [self.forgotPasswordLabel.layer setBorderColor:[[UIColor whiteColor] CGColor]];

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

- (IBAction)forgotPasswordButton:(id)sender {
    [[Model instance]forgotpassword:self.emailLabel.text block:^(BOOL block){
        if (block==NO) {
            NSLog(@"Error reseting password");
        }
        else if(block == YES){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                           message:@"To reset the password please check your email"
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
            [alert addAction:firstAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
}
@end
