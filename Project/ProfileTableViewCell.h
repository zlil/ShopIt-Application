//
//  ProfileTableViewCell.h
//  Project
//
//  Created by tomer aronovsky on 1/8/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
@property (weak, nonatomic) IBOutlet UITextView *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@end
