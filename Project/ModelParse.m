//  ModelParse.m
//  Project
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
#import "ModelParse.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Post.h"
#import "NotificationSql.h"

@implementation ModelParse

-(id)init{
    self = [super init];
    if (self) {
        // Initialize Parse DB
        [Parse setApplicationId:@"KTJpeMRdUlpCLvOFtiV9XE9GBt7lJNJAOo53PhYk"
                      clientKey:@"CyYbBKuyIj2Gc3Lg4XrWiWr9RCecsvvD6GshDPC6"];
    }
    return self;
}

-(BOOL)saveUserSettings:(NSString *)password email:(NSString *)email{
    PFUser *pfuser = [PFUser currentUser];
    if(![password isEqual:@""])
        pfuser.password = password;
    if(![email isEqual:@""])
        pfuser.email = email;
    [pfuser save];
    return YES;
}

-(BOOL)loginUser:(NSString*)username password:(NSString *)password{
    NSError* error;
    PFUser* pfuser = [PFUser logInWithUsername:username password:password error:&error];
    if(error == nil && pfuser !=nil){
        return YES;
    } else {
        NSLog(@"login failed");
        return NO;
    }
}

-(BOOL)createNewUser:(NSString *)username password:(NSString *)password email:(NSString *)email {
    PFUser *userParse = [PFUser user];
    NSError* error;
    userParse.username = username;
    userParse.password = password;
    userParse.email = email;
    return [userParse signUp:&error];
}

-(void)logout{
    [PFUser logOut];
}

-(BOOL)forgotPassword:(NSString*)email{
    [PFUser requestPasswordResetForEmailInBackground:email];
    return YES;
}


-(NSString*)getCurrentUser{
    PFUser *pfuser = [PFUser currentUser];
    if (pfuser != nil) {
        NSString* username = pfuser.username;
        return username;
    }else{
        return nil;
    }
}




-(NSArray*)getStudentsToShowInSearch{
    //NSArray* allUsersSearch = [[NSMutableArray alloc] init];
    NSArray* allUsersSearch = nil;
    //find all users that i follow
    PFQuery *queryUsers = [PFUser query];
    allUsersSearch = [queryUsers findObjects];
    return allUsersSearch;
}

-(UIImage*)getImage:(NSString*)imageName {
    PFQuery* post = [PFQuery queryWithClassName:@"Post"];
    [post whereKey:@"fileName" equalTo:imageName];
    NSArray* res = [post findObjects];
    UIImage* image = nil;
    if (res.count == 1) {
        PFObject* imObj = [res objectAtIndex:0];
        PFFile* file = imObj[@"file"];
        NSData* data = [file getData];
        image = [UIImage imageWithData:data];
    }
    return image;
}


-(BOOL)UserLikePostOrNot:(Post*)post {
    PFQuery* postQuery = [PFQuery queryWithClassName:@"Post"];
    PFUser* user = [PFUser currentUser];
    [postQuery whereKey:@"fileName" equalTo:post.imageName];
    NSArray* res = [postQuery findObjects];
    PFObject* relevantPost = [res objectAtIndex:0];
    //unlike
    if(post.CurrentUserLikeThePostOrNot == NO){
        PFQuery* postlikesQuery = [PFQuery queryWithClassName:@"PostLikesUsers"];
        [postlikesQuery whereKey:@"postId" equalTo:relevantPost];
        [postlikesQuery whereKey:@"userId" equalTo:user];
        NSArray* res1 = [postlikesQuery findObjects];
        PFObject* relevantPostToDelete = [res1 objectAtIndex:0];
        [relevantPostToDelete deleteInBackground];
        
        PFQuery* postQuery = [PFQuery queryWithClassName:@"Notificationes"];
        [postQuery whereKey:@"Post" equalTo:relevantPost];
        NSArray* temp = [[postQuery whereKey:@"userMakeAction" equalTo:user]findObjects];
        PFObject* deleteNotification = [temp objectAtIndex:0];
        [deleteNotification deleteInBackground];
        
        NSNumber* mapXNum = relevantPost[@"count"];
        int nn = [mapXNum intValue] - 1;
        [relevantPost setObject:@(nn) forKey:@"count"];
        [relevantPost saveInBackground];
    }
    //like
    if(post.CurrentUserLikeThePostOrNot == YES) {
        PFObject* addnewLikeForPost = [PFObject objectWithClassName:@"PostLikesUsers"];
        [addnewLikeForPost setObject:user forKey:@"userId"];
        [addnewLikeForPost setObject:relevantPost forKey:@"postId"];
        [addnewLikeForPost saveInBackground];
        
        NSNumber* mapXNum = relevantPost[@"count"];
        int nn = [mapXNum intValue] + 1;
        [relevantPost setObject:@(nn) forKey:@"count"];
        [relevantPost saveInBackground];
        
        PFQuery* postQuery = [PFQuery queryWithClassName:@"Notificationes"];
        [postQuery whereKey:@"Post" equalTo:relevantPost];
        NSArray* temp = [[postQuery whereKey:@"userMakeAction" equalTo:user]findObjects];

        if(temp.count == 0){
            PFQuery *allusers = [PFUser query];
            NSArray* pf = [[allusers whereKey:@"username" equalTo:post.username]findObjects];
            PFObject* passiveUser = [pf objectAtIndex:0];
            PFObject* addnewLikeForNotification = [PFObject objectWithClassName:@"Notificationes"];
            NSString* type = [NSString stringWithFormat:@"like"];
            [addnewLikeForNotification setObject:user forKey:@"userMakeAction"];
            [addnewLikeForNotification setObject:type forKey:@"NotifType"];
            [addnewLikeForNotification setObject:passiveUser forKey:@"userId"];
            [addnewLikeForNotification setObject:relevantPost forKey:@"Post"];
            [addnewLikeForNotification saveInBackground];
        }
        
    }
    return YES;
}


-(NSMutableArray*)getAllPostsForUserProfile:(NSString*)username{
    
    PFQuery *allusers = [PFUser query];
    NSArray* pf = [[allusers whereKey:@"username" equalTo:username]findObjects];
    PFObject* user = [pf objectAtIndex:0];
    
    PFQuery* findUserPosts = [PFQuery queryWithClassName:@"Post"];
    NSArray* allposts = [[findUserPosts whereKey:@"userId" equalTo:user]findObjects];
    
    NSMutableArray* posts = [[NSMutableArray alloc]init];
    
    for(PFObject* p1 in allposts){
        Post* post = [[Post alloc]init:p1[@"price"] comment:p1[@"comment"] linkToBuy:p1[@"linkToBuy"] likes:p1[@"count"]];
        post.imageName = p1[@"fileName"];
        post.starRank = p1[@"userRate"];
        [posts addObject:post];
    }
    return posts;
}

-(NSMutableArray*)getNumberOfFollowersAndFollowings:(NSString*)username {
    PFQuery *allusers = [PFUser query];
    NSArray* pf = [[allusers whereKey:@"username" equalTo:username]findObjects];
    PFObject* user = [pf objectAtIndex:0];

    PFQuery* queryFollowers = [PFQuery queryWithClassName:@"FollowingFollowers"];
    [queryFollowers whereKey:@"followAfterUserId" equalTo:user];
    NSArray* followers = [queryFollowers findObjects];
    
    PFQuery* queryFollowings = [PFQuery queryWithClassName:@"FollowingFollowers"];
    [queryFollowings whereKey:@"followerUserId" equalTo:user];
    NSArray* followings = [queryFollowings findObjects];
    
    NSNumber* followersCount = [NSNumber numberWithInteger:followers.count];
    NSNumber* followingsCount = [NSNumber numberWithInteger:followings.count];

    NSMutableArray* followersFollowings = [[NSMutableArray alloc]init];
    [followersFollowings addObject:followersCount];
    [followersFollowings addObject:followingsCount];
    
    PFUser* current_user = [PFUser currentUser];
    PFQuery* queryFollowOrNot = [PFQuery queryWithClassName:@"FollowingFollowers"];
    [queryFollowOrNot whereKey:@"followerUserId" equalTo:current_user];
    [queryFollowOrNot whereKey:@"followAfterUserId" equalTo:user];
    NSArray* followOrNot = [queryFollowOrNot findObjects];
    if(followOrNot.count > 0){
        [followersFollowings addObject:[NSNumber numberWithInt:1]];
    } else [followersFollowings addObject:[NSNumber numberWithInt:0]];

    return followersFollowings;
    //array[0] - followers number, array[1] - followings number array[2] - current user follow(1) or not(0)
}


-(void)saveNewPost:(Post*)post image:(UIImage*)image {
    PFUser* user = [PFUser currentUser];
    PFObject *addValues= [PFObject objectWithClassName:@"Post"];
    
    NSData* data = UIImageJPEGRepresentation(image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    //for each table
    [addValues setObject:post.comment forKey:@"comment"];
    [addValues setObject:user forKey:@"userId"];
    [addValues setObject:post.starRank forKey:@"userRate"];
    [addValues setObject:post.imageName forKey:@"fileName"];
    [addValues setObject:post.linkToBuy forKey:@"linkToBuy"];
    [addValues setObject:post.price forKey:@"price"];
    [addValues setObject:post.likes forKey:@"count"];
    [addValues setObject:imageFile forKey:@"file"];
    [addValues setObject:post.postID forKey:@"PostID"];
    
    [addValues saveInBackground];
    
    
}


/*
//notification
-(NSArray*)getNotificationToShow{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* NotificationToShow = [[NSMutableArray alloc] init];
    
    PFQuery* queryNotificationes = [PFQuery queryWithClassName:@"Notificationes"];
    NSArray* queryArrayNotification = [[queryNotificationes whereKey:@"userId" equalTo:pfuser]findObjects];
    //[queryNotificationes orderByDescending:@"updatedAt"];
    
    //[queryNotificationes setLimit:20];
    
    for(PFObject* p1 in queryArrayNotification){
        PFUser* userNameTosend = p1[@"userMakeAction"];
        [userNameTosend fetchIfNeeded];
        
        PFQuery* queryPost = [PFQuery queryWithClassName:@"Post"];
        PFUser* f = p1[@"Post"];
        [p1[@"Post"] fetchIfNeeded];
        
        NSArray* arrayOfimg = [[queryPost whereKey:@"objectId" equalTo:f.objectId]findObjects];
        PFObject* p2 = [arrayOfimg objectAtIndex:0];
        
        Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username ImageName:p2[@"fileName"] userName:pfuser.username];
        
        [NotificationToShow addObject:notification];
    }
    return NotificationToShow;
}*/


-(NSArray*)getNotificationToShow{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* NotificationToShow = [[NSMutableArray alloc] init];
    
    PFQuery* queryNotificationes = [PFQuery queryWithClassName:@"Notificationes"];
    NSArray* queryArrayNotification = [[queryNotificationes whereKey:@"userId" equalTo:pfuser]findObjects];
    //[queryNotificationes orderByDescending:@"updatedAt"];
    
    //[queryNotificationes setLimit:20];
    
    for(PFObject* p1 in queryArrayNotification){
        PFUser* userNameTosend = p1[@"userMakeAction"];
        [userNameTosend fetchIfNeeded];
        
        PFQuery* queryType = [PFQuery queryWithClassName:@"Notificationes"];
        NSArray* queryArrayTypes = [[queryType whereKey:@"NotifType" equalTo:@"follow"]findObjects];
        NSLog(@"current user is: %@",pfuser.username);
        
        if(queryArrayTypes.count > 0){
            for (PFObject* t in queryArrayTypes){
                //PFObject* t = [queryArrayTypes objectAtIndex:0];
                PFUser* test=t[@"userId"];
                [test fetchIfNeeded];
                [pfuser fetchIfNeeded];
                
                if ([test.username isEqualToString:pfuser.username]) {
                    PFUser* test2=t[@"userMakeAction"];
                    [test2 fetchIfNeeded];
                    NSString* nameTosend = test2.username;
                    Notifications* tmp =[[Notifications alloc]init:@"follow" user:nameTosend ImageName:@"" userName:pfuser.username];
                    NSLog(@"model parse getNotificaionToShow:");
                    NSLog(@"current user is: %@",test.username);
                    NSLog(@"user make action is: %@",nameTosend);
                    [NotificationToShow addObject:tmp];
                }
                
                
            }
        }
        else {
        NSArray* queryArrayTypes2 = [[queryType whereKey:@"NotifType" equalTo:@"like"]findObjects];
        
        if(queryArrayTypes2.count > 0){
            PFQuery* queryPost = [PFQuery queryWithClassName:@"Post"];
            PFUser* f = p1[@"Post"];
            [f fetchIfNeeded];
            
            NSArray* arrayOfimg = [[queryPost whereKey:@"objectId" equalTo:f.objectId]findObjects];
            PFObject* p2 = [arrayOfimg objectAtIndex:0];
            
            Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username ImageName:p2[@"fileName"] userName:pfuser.username];
            
            [NotificationToShow addObject:notification];
        }
        }
    }
    return NotificationToShow;
}



/*
-(NSArray*)getNotificationFromDate:(NSString*)date{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* NotificationToShow = [[NSMutableArray alloc] init];
    
    PFQuery* queryNotificationes = [PFQuery queryWithClassName:@"Notificationes"];
    [queryNotificationes orderByDescending:@"updatedAt"];
    NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    [queryNotificationes whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    NSArray* queryArrayNotification = [[queryNotificationes whereKey:@"userId" equalTo:pfuser]findObjects];
    
    
    [queryNotificationes setLimit:20];
    
    for(PFObject* p1 in queryArrayNotification){
        PFUser* userNameTosend = p1[@"userMakeAction"];
        [userNameTosend fetchIfNeeded];
        
        PFQuery* queryPost = [PFQuery queryWithClassName:@"Post"];
        PFUser* f = p1[@"Post"];
        [p1[@"Post"] fetchIfNeeded];
        
        NSArray* arrayOfimg = [[queryPost whereKey:@"objectId" equalTo:f.objectId]findObjects];
        PFObject* p2 = [arrayOfimg objectAtIndex:0];
        
        //  Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username ImageName:p2[@"fileName"]];
        Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username  ImageName:p2[@"fileName"] userName:pfuser.username];
        
        [NotificationToShow addObject:notification];
    }
    return NotificationToShow;
}*/



-(NSArray*)getNotificationFromDate:(NSString*)date{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* NotificationToShow = [[NSMutableArray alloc] init];
    
    PFQuery* queryNotificationes = [PFQuery queryWithClassName:@"Notificationes"];
    [queryNotificationes orderByDescending:@"updatedAt"];
    NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    [queryNotificationes whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    NSArray* queryArrayNotification = [[queryNotificationes whereKey:@"userId" equalTo:pfuser]findObjects];
    
    
    [queryNotificationes setLimit:20];
    
    for(PFObject* p1 in queryArrayNotification){
        PFUser* userNameTosend = p1[@"userMakeAction"];
        [userNameTosend fetchIfNeeded];
        NSString* CurrentType = p1[@"NotifType"];
        if ([CurrentType isEqualToString:@"like"]) {
            PFQuery* queryPost = [PFQuery queryWithClassName:@"Post"];
            PFUser* f = p1[@"Post"];
            [p1[@"Post"] fetchIfNeeded];
            
            NSArray* arrayOfimg = [[queryPost whereKey:@"objectId" equalTo:f.objectId]findObjects];
            PFObject* p2 = [arrayOfimg objectAtIndex:0];
            Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username  ImageName:p2[@"fileName"] userName:pfuser.username];
            [NotificationToShow addObject:notification];
        }
        else{
            Notifications* notification = [[Notifications alloc]init:p1[@"NotifType"] user:userNameTosend.username  ImageName:@"" userName:pfuser.username];
            
            [NotificationToShow addObject:notification];
            
        }
        
}
    return NotificationToShow;
}


/*
-(BOOL)userToFollowOrUnfollow:(NSString*)username followOrNot:(NSString*)type key:(NSString*)uniqeFollowID{
    PFUser* current_user = [PFUser currentUser];
    PFQuery *allusers = [PFUser query];
    NSArray* pf = [[allusers whereKey:@"username" equalTo:username]findObjects];
    PFObject* user = [pf objectAtIndex:0];

    if([type isEqualToString:@"Unfollow"]){
        PFQuery* queryfollow = [PFQuery queryWithClassName:@"FollowingFollowers"];
        [queryfollow whereKey:@"followerUserId" equalTo:current_user];
        [queryfollow whereKey:@"followAfterUserId" equalTo:user];
        NSArray* follow = [queryfollow findObjects];
        PFObject* relevantFollowToDelete = [follow objectAtIndex:0];
        [relevantFollowToDelete deleteInBackground];
        return YES;
    }
    else if([type isEqualToString:@"Click To Follow"]){
        PFObject *addValues= [PFObject objectWithClassName:@"FollowingFollowers"];
        [addValues setObject:current_user forKey:@"followerUserId"];
        [addValues setObject:user forKey:@"followAfterUserId"];
        [addValues setObject:uniqeFollowID forKey:@"FollowKey"];
        [addValues saveInBackground];
        return YES;
    }
    
    return NO;
}*/



-(BOOL)userToFollowOrUnfollow:(NSString*)username followOrNot:(NSString*)type key:(NSString*)uniqeFollowID{
    PFUser* current_user = [PFUser currentUser];
    PFQuery *allusers = [PFUser query];
    NSArray* pf = [[allusers whereKey:@"username" equalTo:username]findObjects];
    PFObject* user = [pf objectAtIndex:0];
    
    if([type isEqualToString:@"Unfollow"]){
        PFQuery* queryfollow = [PFQuery queryWithClassName:@"FollowingFollowers"];
        [queryfollow whereKey:@"followerUserId" equalTo:current_user];
        [queryfollow whereKey:@"followAfterUserId" equalTo:user];
        NSArray* follow = [queryfollow findObjects];
        PFObject* relevantFollowToDelete = [follow objectAtIndex:0];
        [relevantFollowToDelete deleteInBackground];
        
        
        PFQuery* postQuery = [PFQuery queryWithClassName:@"Notificationes"];
        [postQuery whereKey:@"userMakeAction" equalTo:current_user];
        NSArray* temp = [[postQuery whereKey:@"userMakeAction" equalTo:current_user]findObjects];
        PFObject* deleteNotification = [temp objectAtIndex:0];
        [deleteNotification deleteInBackground];
        
        return YES;
    }
    else if([type isEqualToString:@"Click To Follow"]){
        PFObject *addValues= [PFObject objectWithClassName:@"FollowingFollowers"];
        [addValues setObject:current_user forKey:@"followerUserId"];
        [addValues setObject:user forKey:@"followAfterUserId"];
        [addValues setObject:uniqeFollowID forKey:@"FollowKey"];
        [addValues saveInBackground];
        
        
        //PFQuery* postQuery = [PFQuery queryWithClassName:@"Notificationes"];
        //[postQuery whereKey:@"userMakeAction" equalTo:current_user];
        //NSArray* temp = [[postQuery whereKey:@"userMakeAction" equalTo:current_user]findObjects];
        
        //if(temp.count == 0){
            PFQuery *allusers = [PFUser query];
            NSArray* pf = [[allusers whereKey:@"username" equalTo:username]findObjects];
            PFObject* passiveUser = [pf objectAtIndex:0];
            PFObject* addnewFollwForNotification = [PFObject objectWithClassName:@"Notificationes"];
            NSString* type = [NSString stringWithFormat:@"follow"];
            [addnewFollwForNotification setObject:current_user forKey:@"userMakeAction"];
            [addnewFollwForNotification setObject:type forKey:@"NotifType"];
            [addnewFollwForNotification setObject:passiveUser forKey:@"userId"];
            //[addnewFollwForNotification setObject:null forKey:@"Post"];
            [addnewFollwForNotification saveInBackground];
        //}
        return YES;
    }
    
    return NO;
}





-(NSArray*)getPostFromDate:(NSString*)date postIds:(NSArray*)postIds{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* postsToShow = [[NSMutableArray alloc] init];
    
    //find all users that i follow
    PFQuery* queryFollows = [PFQuery queryWithClassName:@"FollowingFollowers"];
    [queryFollows whereKey:@"followerUserId" equalTo:pfuser];
    
    //find all posts of users that i follows
    PFQuery *queryPosts = [PFQuery queryWithClassName:@"Post"];
    //[queryPosts orderByDescending:@"updatedAt"];
    //NSArray* p = [queryPosts findObjects];

    //NSDate* dated = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    //[queryPosts whereKey:@"updatedAt" greaterThanOrEqualTo:dated];
    for(Post* p in postIds){
        [queryPosts whereKey:@"PostID" notEqualTo:p.postID];
    }
    
    //NSArray* p = [queryPosts findObjects];
    
    [queryPosts setLimit:20];
    
    NSArray* queryArrayPosts = [[queryPosts whereKey:@"userId" matchesKey:@"followAfterUserId" inQuery:queryFollows]findObjects];
    
    for(PFObject* p1 in queryArrayPosts){
        Post* post = [[Post alloc]init:p1[@"price"] comment:p1[@"comment"] linkToBuy:p1[@"linkToBuy"] likes:p1[@"count"]];
        PFObject* findUserOfPost = [[p1 objectForKey:@"userId"] fetch];
        post.username = findUserOfPost[@"username"];
        post.imageName = p1[@"fileName"];
        post.starRank = p1[@"userRate"];
        post.postID = p1[@"PostID"];
        //check if user like the post or not
        PFQuery* queryFollows = [PFQuery queryWithClassName:@"PostLikesUsers"];
        [queryFollows whereKey:@"postId" equalTo:p1];
        NSArray* q = [[queryFollows whereKey:@"userId" equalTo:pfuser]findObjects];
        if(q.count > 0)
            post.CurrentUserLikeThePostOrNot = YES;
        else post.CurrentUserLikeThePostOrNot = NO;
        
        [postsToShow addObject:post];
    }
    queryArrayPosts = postsToShow;
    return queryArrayPosts;
}

-(NSArray*)getPostsToshow{
    PFUser *pfuser = [PFUser currentUser];
    NSMutableArray* postsToShow = [[NSMutableArray alloc] init];
    
    //find all users that i follow
    PFQuery* queryFollows = [PFQuery queryWithClassName:@"FollowingFollowers"];
    [queryFollows whereKey:@"followerUserId" equalTo:pfuser];
    
    //find all posts of users that i follows
    PFQuery *queryPosts = [PFQuery queryWithClassName:@"Post"];
    [queryPosts orderByDescending:@"updatedAt"];
    [queryPosts setLimit:20];
    
    NSArray* queryArrayPosts = [[queryPosts whereKey:@"userId" matchesKey:@"followAfterUserId" inQuery:queryFollows]findObjects];
    
    for(PFObject* p1 in queryArrayPosts){
        Post* post = [[Post alloc]init:p1[@"price"] comment:p1[@"comment"] linkToBuy:p1[@"linkToBuy"] likes:p1[@"count"]];
        PFObject* findUserOfPost = [[p1 objectForKey:@"userId"] fetch];
        post.username = findUserOfPost[@"username"];
        post.imageName = p1[@"fileName"];
        post.starRank = p1[@"userRate"];
        post.postID = p1[@"PostID"];
        
        //check if user like the post or not
        PFQuery* queryFollows = [PFQuery queryWithClassName:@"PostLikesUsers"];
        [queryFollows whereKey:@"postId" equalTo:p1];
        NSArray* q = [[queryFollows whereKey:@"userId" equalTo:pfuser]findObjects];
        if(q.count > 0)
            post.CurrentUserLikeThePostOrNot = YES;
        else post.CurrentUserLikeThePostOrNot = NO;
        
        [postsToShow addObject:post];
    }
    queryArrayPosts = postsToShow;
    return queryArrayPosts;
}

@end
