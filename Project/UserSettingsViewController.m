//
//  UserSettingsViewController.m
//  Project
//
//  Created by tomer aronovsky on 12/30/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "UserSettingsViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface UserSettingsViewController ()

@end

@implementation UserSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.current_username = [Model instance].current_username;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}



- (IBAction)logout:(id)sender {
    [[Model instance]resetNotify:self.current_username];
    [[Model instance]logout];
    LoginViewController* loginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self presentViewController:loginScreen animated:YES completion:NULL];
}





- (IBAction)saveUserSettings:(id)sender {
    [[Model instance]saveUserSettings:self.changePass.text email:self.changeEmail.text block:^(BOOL res) {
        if(res){
            NSLog(@"sadsasadsa");
        }
        else
        {
            NSLog(@"eerorrrrrr");
        }
    }];

}
@end
