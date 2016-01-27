//
//  ModelSQL.h
//  Project
//
//  Created by Adi Azarya on 11/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import <sqlite3.h>

@interface ModelSQL : NSObject{
    sqlite3 *database;
}

-(NSArray*)getPostsToshow:(NSString*)user;

//notification
-(NSArray*)getNotificationsToshow:(NSString*)user;
-(void)resetNotify:(NSString*)current_user;


//sql
-(void)setNotificationObject:(NSArray*)arr;
-(void)SetfollowersTableSQL:(NSString*)username user:(NSString*)user followOrNot:(NSString*)type key:(NSString*)uniqeFollowID;

-(void)saveNewPost:(Post*)post image:(UIImage*)image;


//date protocol.
-(NSString*)getLastUpdateDate:(NSString*)tableType;
-(void)update:(NSMutableArray*)objects table:(NSString*)tableType;
-(void)setLastUpdateDate:(NSString *)lastUpdate table:(NSString*)tableType;


//postslikesusers
-(BOOL)UserLikePostOrNot:(Post*)postForLike current:(NSString*)current_user;

-(NSArray*)getAllPostsForUserProfile:(NSString*)username;
-(NSArray*)getNumberOfFollowersAndFollowings:(NSString*)username current:(NSString*)currentuser;

@end