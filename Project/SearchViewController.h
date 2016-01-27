//
//  SearchViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/3/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* searchTableView;
    IBOutlet UISearchBar* searchBar;
    NSMutableArray* totalUsers;
    NSMutableArray* filteredItems;
    NSMutableArray* filteredItemsNames;
    NSMutableArray* totalUsersNames;
    BOOL isFiltered;
    
}
@property NSString* username;

@end
