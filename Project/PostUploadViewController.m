//
//  PostUploadViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/6/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "PostUploadViewController.h"
#import "NewsFeedTableViewController.h"
#import "Post.h"
#import "Model.h"
#include <stdlib.h>

@interface PostUploadViewController () <UITextViewDelegate>

@end

@implementation PostUploadViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.imageItem setImage:self.imageToDisplay.image];
    self.facebookFlag =FALSE;
    self.twitterFlag =FALSE;
    
    self.comment.delegate = self;
    self.comment.text = @"Write a comment..";
    self.comment.tag = 1;
    self.price.delegate = self;
    self.price.text = @"Product price..";
    self.price.tag = 2;
    self.url.delegate = self;
    self.url.text = @"Url to buy..";
    self.url.tag = 3;
}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write a comment.."]) {
        textView.text = @"";
    }
    else if ([textView.text isEqualToString:@"Product price.."]) {
        textView.text = @"";
    }
    else if ([textView.text isEqualToString:@"Url to buy.."]) {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag == 1){
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Write a comment..";
        }
    }
    if(textView.tag == 2){
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Product price..";
        }
    }
    else if(textView.tag == 3){
        if ([textView.text isEqualToString:@""]) {
            textView.text = @"Url to buy..";
        }
    }
    [textView resignFirstResponder];
}



- (IBAction)backToPost:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButton:(id)sender {
    
    if([self.comment.text isEqualToString:@"Write a comment.."] || [self.price.text isEqualToString:@"Product price.."] || [self.url.text isEqualToString:@"Url to buy.."]){
     
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops.."
                                                                       message:@"You must enter valid comment, price and url"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        }
    else {
        NSNumber* likes = [NSNumber numberWithInt:0];
        Post* post = [[Post alloc]init:self.price.text comment:self.comment.text linkToBuy:self.url.text likes:likes];
        post.starRank = [NSNumber numberWithInt:self.starRank];
        int PicID = arc4random_uniform(99999999);
        NSString* picName = [NSString stringWithFormat:@"%d", PicID];
        post.imageName = picName;
        UIImage* image = self.imageItem.image;
        post.username = [[Model instance]current_username];
        
        long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
        NSString *currentTimeToSend = [NSString stringWithFormat:@"%ld", currentTime];
        NSString* uniqePostID = [NSString stringWithFormat:@"%@%@",currentTimeToSend,post.username];
        post.postID = uniqePostID;
        
        
        [[Model instance]saveNewPost:post image:image block:^(NSError* res){
            if(res)
            {
                NSLog(@"error uploading post");
            }
            else [self performSegueWithIdentifier:@"moveToNews" sender:self];
        }];

    }
}



- (IBAction)faceBookButton:(id)sender {
    if(self.facebookFlag == FALSE){
        [self.facebook setImage:[UIImage imageNamed:@"facebook.png"]forState:UIControlStateNormal];
        self.facebookFlag =true;
    }
    else{
        [self.facebook setImage:[UIImage imageNamed:@"facebookOff.png"]forState:UIControlStateNormal];
        self.facebookFlag = FALSE;
    }
}



- (IBAction)star1Button:(id)sender {
    [self.star2 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star1 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    self.starRank = 1;
}


- (IBAction)star2Button:(id)sender {
    [self.star3 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star1 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    self.starRank = 2;
    
    
    
}

- (IBAction)star3Button:(id)sender {
    [self.star4 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star1 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    self.starRank = 3;
}

- (IBAction)star4Button:(id)sender {
    [self.star5 setImage:[UIImage imageNamed:@"starRateX.png"]forState:UIControlStateNormal];
    [self.star1 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    self.starRank = 4;
}

- (IBAction)star5Button:(id)sender {
    [self.star1 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star2 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star3 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star4 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    [self.star5 setImage:[UIImage imageNamed:@"starRateV.png"]forState:UIControlStateNormal];
    self.starRank = 5;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}



@end
