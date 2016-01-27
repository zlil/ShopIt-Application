//
//  PostScreenViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/18/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *link;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *comment;
@property (weak, nonatomic) IBOutlet UILabel *likes;
@property (weak, nonatomic) IBOutlet UIImageView *stars;


@property NSString* commentStr;
@property NSString* likes1;
@property NSString* imageName;
@property NSNumber* starRank;
@property NSString* linkToBuy;


@property NSNumber* starRank1;

@end
