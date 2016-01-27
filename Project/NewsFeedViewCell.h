//
//  NewsFeedTableViewCell.h
//  Project
//
//  Created by tomer aronovsky on 1/1/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)shareButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeThisPostLabel;
- (IBAction)likeThisPostButton:(id)sender;
@property NSString* imageName;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyItemButton;
@property (weak, nonatomic) IBOutlet UIButton *likeOrUnlikeButton;
@property (weak, nonatomic) IBOutlet UIImageView *rankImage;

@end
