//
//  PostScreenViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/18/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "PostScreenViewController.h"
#import "Post.h"
#import "Model.h"

@interface PostScreenViewController ()

@end

@implementation PostScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Post* post = [[Post alloc]init];
    post.imageName = self.imageName;
    self.starRank1 = self.starRank;
    [self.link addTarget:self action:@selector(buyItem) forControlEvents:UIControlEventTouchUpInside];

    
    [[Model instance]getPostImage:post block:^(UIImage* imageFromDb) {
        self.image.image = imageFromDb;
        self.likes.text = self.likes1;
        self.comment.text = self.commentStr;
        
    }];

    
    if(self.starRank1 == [NSNumber numberWithLong:0]){
        self.stars.image = [UIImage imageNamed:@"0stars.png"];
    }else if(self.starRank1 == [NSNumber numberWithLong:1]){
        self.stars.image = [UIImage imageNamed:@"1stars.png"];
    }else if(self.starRank1 == [NSNumber numberWithLong:2]){
        self.stars.image = [UIImage imageNamed:@"2stars.png"];
    }else if(self.starRank1 == [NSNumber numberWithLong:3]){
        self.stars.image = [UIImage imageNamed:@"3stars.png"];
    }else if(self.starRank1 == [NSNumber numberWithLong:4]){
        self.stars.image = [UIImage imageNamed:@"4stars.png"];
    }else if(self.starRank1 == [NSNumber numberWithLong:5]){
        self.stars.image = [UIImage imageNamed:@"5stars.png"];
    }



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

-(void)buyItem {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: self.linkToBuy]];
}




@end
