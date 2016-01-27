//
//  MyProfileTableViewCell.h
//  Project
//
//  Created by tomer aronovsky on 1/15/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end
