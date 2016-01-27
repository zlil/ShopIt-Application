//
//  ProfileViewController.m
//  Project
//
//  Created by tomer aronovsky on 12/30/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "ProfileTableViewCell.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    if(self.username == NULL){
        PFUser* user = [PFUser currentUser];
        self.username = user[@"username"];
        [self.FollowUnfollowLabel setHidden:YES];
        //custom settings button
        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsView)];
        self.navigationItem.rightBarButtonItem = settingsButton;
    }
    else {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        CGRect frame = self.usernameHeadLabel.frame;
        frame.origin.y -= 45;
        self.usernameHeadLabel.frame = frame;
    }
    
    //get posts to show in profile page
    //posts = [[Model instance]getAllPostsForUserProfile:self.username];
    //self.postsNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)posts.count];
    /*
    
    [[Model instance]getNumberOfFollowersAndFollowings:self.username block:^(NSArray* followersFollowings){
        NSNumber* g_followers = [followersFollowings objectAtIndex:0];
        NSNumber* g_followings = [followersFollowings objectAtIndex:1];
        NSString* s_followers = [NSString stringWithFormat:@"%@", g_followers];
        NSString* s_followings = [NSString stringWithFormat:@"%@", g_followings];
        self.followersNumber.text = s_followers;
        self.followingsNumber.text = s_followings;
        
        NSNumber* followOrNot = [followersFollowings objectAtIndex:2];
        if([followOrNot isEqual:@1]){
            self.followOrNot = YES;
            [self.FollowUnfollowLabel setBackgroundColor:[UIColor colorWithRed:0x33/255.0 green:0 blue:0x99/255.0 alpha:1.0]];
            [self.FollowUnfollowLabel setTitle:@"Unfollow" forState:UIControlStateNormal];
        }
        else {
            self.followOrNot = NO;
            }
      }];
    
    self.usernameHeadLabel.text = self.username;*/
}

-(IBAction)settingsView
{
    [self performSegueWithIdentifier:@"UserSettings" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)viewDidAppear:(BOOL)animated{
    [[Model instance]getAllPostsForUserProfile:self.username block:^(NSArray* allpoststouser){
        posts = (NSMutableArray*)allpoststouser;
        self.postsNumber.text = [NSString stringWithFormat:@"%lu", (unsigned long)posts.count];
    }];
    

}*/



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return posts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTableViewCell" forIndexPath:indexPath];

    Post* aaa = [posts objectAtIndex:indexPath.row];
    cell.commentLabel.text = aaa.comment;
    NSString *convertNumberToString = [NSString stringWithFormat:@"%@", aaa.likes];

    cell.likesLabel.text = convertNumberToString;
    [[Model instance] getPostImage:aaa block:^(UIImage *image) {
            if (image != nil)
            {
                cell.imagePost.image = image;
            }
            else{
                cell.imagePost.image = [UIImage imageNamed:@"no_photo.jpg"];
            }
    }];
    return cell;
}

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)FollowUnFollowButton:(id)sender {
    NSString* buttonText = [self.FollowUnfollowLabel titleForState:UIControlStateNormal];
    if([buttonText isEqualToString:@"Click To Follow"]){
        [[Model instance]userToFollowOrUnfollow:self.username followOrNot:[NSString stringWithFormat:@"Click To Follow"] block:^(BOOL block){
            self.followOrNot = YES;
            [self.FollowUnfollowLabel setBackgroundColor:[UIColor colorWithRed:0x33/255.0 green:0 blue:0x99/255.0 alpha:1.0]];
            [self.FollowUnfollowLabel setTitle:@"Unfollow" forState:UIControlStateNormal];
        }];
    }
    else if([buttonText isEqualToString:@"Unfollow"]){
        [[Model instance]userToFollowOrUnfollow:self.username followOrNot:[NSString stringWithFormat:@"Unfollow"] block:^(BOOL block){
            self.followOrNot = NO;
            [self.FollowUnfollowLabel setBackgroundColor:[UIColor colorWithRed:98.0f/255.0f green:200.0f/255.0f blue:78/255.0f alpha:1.0f]];
            [self.FollowUnfollowLabel setTitle:@"Click To Follow" forState:UIControlStateNormal];
        }];

    }
}
@end
