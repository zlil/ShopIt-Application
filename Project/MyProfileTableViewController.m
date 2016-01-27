//
//  MyProfileTableViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/15/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import "Model.h"
#import "MyProfileTableViewCell.h"
#import <Parse/Parse.h>
#import "PostScreenViewController.h"


@interface MyProfileTableViewController ()

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.username == NULL){
        self.username = [Model instance].current_username;
        
        //custom settings button
        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(settingsView)];
        self.navigationItem.rightBarButtonItem = settingsButton;
    }
    
    
    MyProfileTableViewController* child = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"childViewController"];
    [self addChildViewController:child];
    child.username = self.username;
    child.view.frame = self.topViewContainer.frame;
    [self.topViewContainer addSubview:child.view];
    [child didMoveToParentViewController:self];

    
    
    [[Model instance]getAllPostsForUserProfile:self.username block:^(NSArray* allpoststouser){
        _posts = (NSMutableArray*)allpoststouser;
        [self.tableView reloadData];
    }];
    
}

-(IBAction)settingsView
{
    [self performSegueWithIdentifier:@"UserSettings" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileTableViewCell" forIndexPath:indexPath];
    
    Post* aaa = [self.posts objectAtIndex:indexPath.row];
    cell.commentLabel.text = aaa.comment;
    NSString *convertNumberToString = [NSString stringWithFormat:@"%@", aaa.likes];
    cell.likesLabel.text = convertNumberToString;
    [[Model instance] getPostImage:aaa block:^(UIImage *image) {
        if (image != nil)
        {
            cell.postImage.image = image;
        }
        else{
            cell.postImage.image = [UIImage imageNamed:@"no_photo.jpg"];
        }
    }];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"fromProfileToPostScreen"]){
            NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
            Post* postOrigin = [self.posts objectAtIndex:ip.row];
            PostScreenViewController* postDestenation = segue.destinationViewController;
            
        postDestenation.commentStr = postOrigin.comment;
        postDestenation.likes1 = [postOrigin.likes stringValue];
        postDestenation.imageName = postOrigin.imageName;
        postDestenation.linkToBuy = postOrigin.linkToBuy;
        postDestenation.starRank = postOrigin.starRank;
    }
}

@end
