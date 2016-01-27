//
//  NotificationTableViewCell.h
//  Project
//
//  Created by tomer aronovsky on 1/9/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *userNameDisplay;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *notificationImage;

@end
