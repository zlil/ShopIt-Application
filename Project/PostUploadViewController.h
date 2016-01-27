//
//  PostUploadViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/6/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface PostUploadViewController : UIViewController<UITextFieldDelegate>

@property UIImageView* imageToDisplay;
@property int starRank;
@property BOOL facebookFlag;
@property BOOL twitterFlag;

- (IBAction)backToPost:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageItem;
- (IBAction)shareButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UITextView *url;
@property (weak, nonatomic) IBOutlet UITextView *price;

- (IBAction)faceBookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *facebook;

- (IBAction)star1Button:(id)sender;
- (IBAction)star2Button:(id)sender;
- (IBAction)star3Button:(id)sender;
- (IBAction)star4Button:(id)sender;
- (IBAction)star5Button:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *star1;
@property (weak, nonatomic) IBOutlet UIButton *star2;
@property (weak, nonatomic) IBOutlet UIButton *star3;
@property (weak, nonatomic) IBOutlet UIButton *star4;
@property (weak, nonatomic) IBOutlet UIButton *star5;




@end
