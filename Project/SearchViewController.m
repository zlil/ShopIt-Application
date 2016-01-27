//
//  SearchViewController.m
//  Project
//
//  Created by tomer aronovsky on 1/3/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "SearchViewController.h"
#import "Model.h"
#import "SearchTableViewCell.h"
#import "User.h"
#import "MyProfileTableViewController.h"
#import <Parse/Parse.h>


@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchBar.delegate = self;
    filteredItems = [[NSMutableArray alloc]init];
    filteredItemsNames = [[NSMutableArray alloc]init];
    totalUsersNames = [[NSMutableArray alloc]init];

    totalUsers = [[NSMutableArray alloc]init];
    [[Model instance]getUsersToshowInSearchAsynch:^(NSArray* postsArray){
        totalUsers = (NSMutableArray*)postsArray;
        [searchTableView reloadData];
    }];


    
}




-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if(searchText.length == 0){
        isFiltered = NO;
        filteredItems = [[NSMutableArray alloc]init];
    }
    else
    {
        filteredItems = [[NSMutableArray alloc]init];
        isFiltered = YES;
        for (int i = 0; i < [totalUsers count]; i++){
            PFUser* pp = (PFUser*)[totalUsers objectAtIndex:i];
            if([pp.username hasPrefix:searchText]){
               [filteredItems addObject:pp];
            }
        }
    }
    [searchTableView reloadData];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(isFiltered)
        return filteredItems.count;
    return totalUsers.count;
}




-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchViewCell" forIndexPath:indexPath];
    
    if(isFiltered){
        User* user = [filteredItems objectAtIndex:indexPath.row];
        cell.usernameLabel.text = (NSString*)user.username;
        cell.goToProfile.tag = indexPath.row;
    }
    else if(!isFiltered) {
        User* user = [totalUsers objectAtIndex:indexPath.row];
        cell.usernameLabel.text = user.username;
        cell.goToProfile.tag = indexPath.row;
    }
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (IBAction)buttonToProfile:(id)sender {
    UIButton* senderBut = (UIButton*)sender;
    int index = senderBut.tag;
    if(isFiltered){
        User* user = [filteredItems objectAtIndex:index];
        self.username = user.username;
    }
    else {
        User* user = [totalUsers objectAtIndex:index];
        self.username = user.username;
    }
    
    //[self performSegueWithIdentifier:@"fromSearchToProfileSeg" sender:nil];
}*/


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"cell selected");
//
//    if(isFiltered){
//        User* user = [filteredItems objectAtIndex:indexPath.row];
//        self.username = user.username;
//    }
//    else {
//        User* user = [totalUsers objectAtIndex:indexPath.row];
//        self.username = user.username;
//    }
//    [self performSegueWithIdentifier:@"fromSearchToProfile" sender: indexPath];
//    //[self performSegueWithIdentifier:@"fromSearchToProfile" sender:nil];
//}




#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"fromSearchToProfile"]){
        
        NSIndexPath *ip = [searchTableView indexPathForSelectedRow];
        NSLog(@"%ld",(long)ip.row);
        //NSString* name = [[NSString alloc]init];
        NSString* name = nil;
        if(isFiltered){
            User* user = [filteredItems objectAtIndex:ip.row];
            name = user.username;
        }
        else {
            User* user = [totalUsers objectAtIndex:ip.row];
            name = user.username;
        }
        

        /*UINavigationController* nav = segue.destinationViewController;
        MyProfileTableViewController *pro = (MyProfileTableViewController*)nav;
        pro.username = self.username;*/
        
        //UINavigationController *nav = segue.destinationViewController;
        MyProfileTableViewController* m = segue.destinationViewController;
        m.username = name;
    }
}

@end
