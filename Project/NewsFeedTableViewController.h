//
//  NewsFeedTableViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/1/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewController : UITableViewController{
     NSMutableArray* posts;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadNesFeedIndicator;
- (IBAction)fromNewsFeedToProfile:(id)sender;

@property NSString* username;

@property BOOL showPopUpForNewUsers;


@end
