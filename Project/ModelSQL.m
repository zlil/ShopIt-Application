//
//  ModelSQL.m
//  Project
//
//  Created by Adi Azarya on 11/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelSQL.h"
#import "PostSql.h"
#import "NotificationSql.h"
#import "LastUpdateSql.h"
#import "FollowingFollowersSql.h"
#import "updateProtocol.h"

@implementation ModelSQL

static NSString* POSTS_TABLE = @"POSTS";
static NSString* FOLLOWINGFOLLOWERS_TABLE = @"FOLLOWINGFOLLOWERS";
static NSString* NOTIFICATIONS_TABLE = @"NOTIFICATIONS";

-(id)init{
    self = [super init];
    if(self){
    //sql -> init the dataBase, happens only once.
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray* paths = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL* directoryUrl = [paths objectAtIndex:0];
    NSURL* fileUrl = [directoryUrl URLByAppendingPathComponent:@"database.db"];
    
    NSString *filePath = [fileUrl path];
    const char* cFilePath = [filePath UTF8String];
    int res = sqlite3_open(cFilePath,&database);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: fail to open db");
        database=nil;
    }
    
    [LastUpdateSql createTable:database];
    [PostSql createTable:database];
    [PostSql createPostsLikeUsersTable:database];
    [NotificationSql createNotificationTable:database];
    [FollowingFollowersSql createTable:database];
    
    }
    return self;
}

-(void)saveNewPost:(Post*)post image:(UIImage*)image{
    [PostSql saveNewPost:post db:database];
}

-(NSArray*)getPostsToshow:(NSString*)user{
    return [PostSql getPostsToshow:database user:user];
}

-(void)setNotificationObject:(NSArray*)notiArr{
    
    [NotificationSql saveNewNotification:database notifications:notiArr];
    
}

-(NSArray*)getNotificationsToshow:(NSString*)user{
    return [NotificationSql getNotificationsToshow:database user:user];
}




//follow & followers
-(void)SetfollowersTableSQL:(NSString*)username user:(NSString*)user followOrNot:(NSString*)type key:(NSString*)uniqeFollowID{
    if ([type isEqualToString:@"Click To Follow"]) {
        [FollowingFollowersSql addFollowingRelation:username currenuser:user db:database key:uniqeFollowID];
    }
    else {
        [FollowingFollowersSql deleteFollowingRelation2:(sqlite3*)database key:uniqeFollowID];
    }
}


//----- UPDATE PROTOCOL ----//
-(NSString*)getLastUpdateDate:(NSString*)tableType{
    if ([tableType  isEqual: @"Post"])
        return [updateProtocol getLastUpdateDate:database tableType:POSTS_TABLE];
    else if ([tableType  isEqual: @"Notification"])
        return [updateProtocol getLastUpdateDate:database tableType:NOTIFICATIONS_TABLE];
    else
        NSLog (@"error");
    
    return @"error";
}


-(void)update:(NSMutableArray*)objects table:(NSString*)tableType{
    if ([tableType  isEqual: @"Post"])
        [updateProtocol updateTable:database Objects:objects table:POSTS_TABLE];
    else if ([tableType  isEqual: @"Notification"])
        [updateProtocol updateTable:database Objects:objects table:NOTIFICATIONS_TABLE];
    else
        NSLog (@"error");
    
}


-(void)setLastUpdateDate:(NSString *)lastUpdate table:(NSString*)tableType{
    if ([tableType  isEqual: @"Post"])
        [updateProtocol setLastUpdateDate:database date:lastUpdate table:POSTS_TABLE];
    else if ([tableType  isEqual: @"Notification"])
        [updateProtocol setLastUpdateDate:database date:lastUpdate table:NOTIFICATIONS_TABLE];
    else
        NSLog (@"error");
}
//-----------------------------//


-(void)resetNotify:(NSString*)current_user {
    
    
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"DELETE FROM NOTIFICATIONS WHERE USERNAME like '%@';", current_user];
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        if(sqlite3_step(statment) == SQLITE_DONE){
            //NSDate *date = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
            [updateProtocol setLastUpdateDate:database date:[NSString stringWithFormat:@"0"] table:NOTIFICATIONS_TABLE];
            return;
        }
    }
    
    
}


-(NSArray*)getNumberOfFollowersAndFollowings:(NSString*)username current:(NSString*)currentuser{
    NSArray* arr = [FollowingFollowersSql getNumberOfFollowersAndFollowings:username current:currentuser db:database];
    return arr;
}


-(NSArray*)getAllPostsForUserProfile:(NSString*)username{
    return [PostSql getAllPostsForUserProfile:username db:database];
    
}


-(BOOL)UserLikePostOrNot:(Post*)postForLike current:(NSString*)current_user{
    return [PostSql UserLikePostOrNot:postForLike current:current_user db:database];
}

@end