//
//  SearchTableViewCell.h
//  Project
//
//  Created by tomer aronovsky on 1/3/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UIButton *goToProfile;

@end
