//
//  ChildMyProfileViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/15/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "ChildMyProfileViewController.h"
#import "Model.h"


@interface ChildMyProfileViewController ()

@end

@implementation ChildMyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if(self.username == [Model instance].current_username){
        [self.ButtonLabel setHidden:YES];
    } else {
        if(![[Model instance].current_username isEqualToString:self.username]){
            [[self navigationController] setNavigationBarHidden:YES animated:YES];
            CGRect frame = self.usernameHeadText.frame;
            self.usernameHeadText.frame = frame;
        }
    }
    self.usernameHeadText.text = self.username;
    [[Model instance]getNumberOfFollowersAndFollowings:self.username currentUser:[Model instance].current_username block:^(NSArray* followersFollowings){
        NSString* followersNumber = [followersFollowings objectAtIndex:0];
        NSString* followingsNumber = [followersFollowings objectAtIndex:1];
        self.followersLabel.text = [NSString stringWithFormat:@"%@", followersNumber];
        self.followingsLabel.text = [NSString stringWithFormat:@"%@", followingsNumber];
        
        NSNumber* followOrNot = [followersFollowings objectAtIndex:2];
        if([followOrNot isEqual:@1]){
            self.followOrNot = YES;
            [self.ButtonLabel setBackgroundColor:[UIColor colorWithRed:0x33/255.0 green:0 blue:0x99/255.0 alpha:1.0]];
            [self.ButtonLabel setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else {
            self.followOrNot = NO;
        }
    }];
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

- (IBAction)ButtonFollow:(id)sender {
    NSString* buttonText = [self.ButtonLabel titleForState:UIControlStateNormal];
    if([buttonText isEqualToString:@"Click To Follow"]){
        [[Model instance]userToFollowOrUnfollow:self.username followOrNot:[NSString stringWithFormat:@"Click To Follow"] block:^(BOOL block){
            self.followOrNot = YES;
            [self.ButtonLabel setBackgroundColor:[UIColor colorWithRed:0x33/255.0 green:0 blue:0x99/255.0 alpha:1.0]];
            [self.ButtonLabel setTitle:@"Unfollow" forState:UIControlStateNormal];
        }];
    }
    else if([buttonText isEqualToString:@"Unfollow"]){
        [[Model instance]userToFollowOrUnfollow:self.username followOrNot:[NSString stringWithFormat:@"Unfollow"] block:^(BOOL block){
            self.followOrNot = NO;
            [self.ButtonLabel setBackgroundColor:[UIColor colorWithRed:98.0f/255.0f green:200.0f/255.0f blue:78/255.0f alpha:1.0f]];
            [self.ButtonLabel setTitle:@"Click To Follow" forState:UIControlStateNormal];
        }];
        
    }



}
@end
