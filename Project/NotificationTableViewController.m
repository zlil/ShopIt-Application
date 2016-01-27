//
//  NotificationTableViewController.m
//  Project
//
//  Created by Adi Azarya on 06/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "Model.h"
#import "Notifications.h"
#import "Post.h"
#import "NotificationTableViewCell.h"

@implementation NotificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    notifications = [[NSMutableArray alloc]init];
    [[Model instance]getNotificationArray:^(NSArray* userArray){
        notifications = (NSMutableArray*)userArray;
        [self.tableView reloadData];
    }];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return notifications.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationViewCell" forIndexPath:indexPath];
    
    Notifications *notification = [notifications objectAtIndex:indexPath.row];
    
    if(notification != NULL) {
        if([notification.type  isEqual: @"follow"]){
            [cell.userNameDisplay setTitle:notification.userName forState:UIControlStateNormal ];
            cell.notificationLabel.text = @"Has Started Follow You";
            cell.notificationImage.image = NULL;
            
        }
        else{
            cell.notificationLabel.text = @"Liked Your Post";
            [cell.userNameDisplay setTitle:notification.userName forState:UIControlStateNormal ];
            
            
            [[Model instance] getNotificationImage:notification block:^(UIImage *image) {
                cell.notificationImage.image = image;
            }];
        }
    }
    
    
    return cell;
}







@end