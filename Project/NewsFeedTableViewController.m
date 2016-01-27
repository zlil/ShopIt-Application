//
//  NewsFeedTableViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/1/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "NewsFeedTableViewController.h"
#import "Model.h"
#import "NewsFeedViewCell.h"
#import "Post.h"
#import "MyProfileTableViewController.h"

@interface NewsFeedTableViewController ()

@end

@implementation NewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // ------- Customize NewsFeed --------//
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Miss Issippi Demo" size:30.0f],
                                                            }];
    [self.loadNesFeedIndicator startAnimating];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    //----- Get posts to show in NewsFeed -----//
    [super viewWillAppear:animated];
    
    posts = [[NSMutableArray alloc]init];
    [[Model instance]getPostsToshowAsynch:^(NSMutableArray* postsArray){
        posts = postsArray;
        [self.tableView reloadData];
        self.loadNesFeedIndicator.hidden = YES;
        if(posts.count==0){
            
            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Welcome to ShopIt" message: @"To improve your online shopping experince, start follow your friends and share your products with everyone" delegate: self cancelButtonTitle: @"Lets Start!" otherButtonTitles: nil];
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 40, 40)];
            NSString *loc = [[NSString alloc] initWithString:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"newsfeed.jpg"]];
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:loc];
            [image setImage:img];
            [someError setValue:image forKey:@"accessoryView"];
            [someError show];
        }
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return posts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsFeedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsFeedViewCell" forIndexPath:indexPath];
    Post* post = [posts objectAtIndex:indexPath.row];
    cell.priceLabel.text = post.price;
    cell.commentLabel.text = post.comment;
    cell.imageName = post.imageName;
    cell.imageView.image = nil;
    NSString *convertNumberToString = [NSString stringWithFormat:@"%@", post.likes];
    NSString* likesThisPost = [NSString stringWithFormat:@"Likes this post"];
    NSString* finalLikesLabel = [NSString stringWithFormat:@"%@ %@", convertNumberToString, likesThisPost];
    cell.likesLabel.text = finalLikesLabel;
    [cell.usernameLabel setTitle:post.username forState:UIControlStateNormal];
    cell.buyItemButton.tag = indexPath.row;
    [cell.buyItemButton addTarget:self action:@selector(buyItemClick:) forControlEvents:UIControlEventTouchUpInside];
    if (post.CurrentUserLikeThePostOrNot == NO) {
        UIImage *btnImage = [UIImage imageNamed:@"not-love.png"];
        [cell.likeOrUnlikeButton setImage:btnImage forState:UIControlStateNormal];
    }
    else if(post.CurrentUserLikeThePostOrNot == YES){
        UIImage *btnImage = [UIImage imageNamed:@"love.png"];
        [cell.likeOrUnlikeButton setImage:btnImage forState:UIControlStateNormal];
    }
    cell.likeOrUnlikeButton.tag = indexPath.row;
    [cell.likeOrUnlikeButton addTarget:self action:@selector(likeOrUnlikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(post.imageName != nil && ![post.imageName isEqualToString:@""]){
        [[Model instance] getPostImage:post block:^(UIImage *image) {
            if ([cell.imageName isEqualToString:post.imageName]){
                if (image != nil) {
                    cell.image.image = image;
                }else{
                    cell.image.image = [UIImage imageNamed:@"no_photo.jpg"];
                }
            }
        }];
    }
    
    if(post.starRank == [NSNumber numberWithInt:0]){
        cell.rankImage.image = [UIImage imageNamed:@"0stars.png"];
    }else if(post.starRank == [NSNumber numberWithInt:1]){
        cell.rankImage.image = [UIImage imageNamed:@"1stars.png"];
    }else if(post.starRank == [NSNumber numberWithInt:2]){
        cell.rankImage.image = [UIImage imageNamed:@"2stars.png"];
    }else if(post.starRank == [NSNumber numberWithInt:3]){
        cell.rankImage.image = [UIImage imageNamed:@"3stars.png"];
    }else if(post.starRank == [NSNumber numberWithInt:4]){
        cell.rankImage.image = [UIImage imageNamed:@"4stars.png"];
    }else if(post.starRank == [NSNumber numberWithInt:5]){
        cell.rankImage.image = [UIImage imageNamed:@"5stars.png"];
    }
    
    cell.usernameLabel.tag = indexPath.row;
    return cell;
}




-(void)buyItemClick:(id)sender{
    UIButton* senderBut = (UIButton*)sender;
    Post* post = [posts objectAtIndex:senderBut.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: post.linkToBuy]];
}

-(void)likeOrUnlikeClick:(id)sender{
    UIButton* senderBut = (UIButton*)sender;
    Post* post = [posts objectAtIndex:senderBut.tag];
    if(post.CurrentUserLikeThePostOrNot==YES){ //it's mean that we want to delete the row in DB...
        [[Model instance] UserLikePostOrNot:post block:^(BOOL bbb){
        }];
        post.CurrentUserLikeThePostOrNot = NO;
        
        int value = [post.likes intValue];
        post.likes = [NSNumber numberWithInt:value - 1];
    }
    else if(post.CurrentUserLikeThePostOrNot==NO){
        [[Model instance] UserLikePostOrNot:post block:^(BOOL bbb){ //it's mean that we want to add new row in DB...
        }];
        post.CurrentUserLikeThePostOrNot = YES;
        
        int value = [post.likes intValue];
        post.likes = [NSNumber numberWithInt:value + 1];
    }

    [self.tableView reloadData];
    [posts replaceObjectAtIndex:senderBut.tag withObject:post];
     NSLog(@"user like/unlike this post");
}



- (IBAction)fromNewsFeedToProfile:(id)sender {
    UIButton* senderBut = (UIButton*)sender;
    NSInteger* i = (NSInteger*)senderBut.tag;
    Post* post = [posts objectAtIndex:(long)i];
    self.username = post.username;
    [self performSegueWithIdentifier:@"fromNewsFreedToProfile" sender:nil];
}




// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"fromNewsFreedToProfile"]){
        UINavigationController *nav = segue.destinationViewController;
        MyProfileTableViewController* profileVC = (MyProfileTableViewController*) nav.topViewController;
        profileVC.username = self.username;
    }
}








@end
