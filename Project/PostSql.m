//
//  PostSql.m
//  Project
//
//  Created by Adi Azarya on 11/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostSql.h"
#import "Post.h"
#import <sqlite3.h>
#import "LastUpdateSql.h"

@implementation PostSql

static NSString* POSTS_TABLE = @"POSTS";
static NSString* POST_ID = @"POST_ID";
static NSString* POST_USERNAME = @"POST_USERNAME";
static NSString* POST_COMMENT = @"POST_COMMENT";
static NSString* POST_LINK = @"POST_LINK";
static NSString* POST_LIKES = @"POST_LIKES";
static NSString* POST_IMAGENAME = @"POST_IMAGENAME";
static NSString* POST_STARANK = @"POST_STARANK";
static NSString* POST_PRICE = @"POST_PRICE";


static NSString* POSTSLIKESUSERS_TABLE = @"POSTSLIKESUSERS";
static NSString* POSTSLIKESUSERS_ID = @"POSTSLIKESUSERS_ID";
static NSString* POSTSLIKESUSERS_POSTID = @"POSTSLIKESUSERS_POSTID";
static NSString* POSTSLIKESUSERS_POSTUSERNAME = @"POSTSLIKESUSERS_POSTUSERNAME";



//create the tables for the first time
+(BOOL)createTable:(sqlite3*)database{
    char* errormsg;
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, %@ INTEGER, %@ TEXT)",POSTS_TABLE,POST_ID,POST_USERNAME,POST_COMMENT,POST_LINK,POST_LIKES,POST_IMAGENAME,POST_STARANK,POST_PRICE];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating POSTS table");
        return NO;
    }
    return YES;
}



+(BOOL)createPostsLikeUsersTable:(sqlite3*)database
{
    char* errormsg;
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT)",POSTSLIKESUSERS_TABLE,POSTSLIKESUSERS_ID,POSTSLIKESUSERS_POSTID,POSTSLIKESUSERS_POSTUSERNAME];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating POSTSLIKESUSERS table");
        return NO;
    }
    return YES;
}

//insert new post to POSTS table
+(void)saveNewPost:(Post*)post db:(sqlite3*)database{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@ , %@ , %@ , %@ , %@ , %@ , %@ , %@ ) values (?,?,?,?,?,?,?,?);",POSTS_TABLE,POST_ID,POST_USERNAME,POST_COMMENT,POST_LINK,POST_LIKES,POST_IMAGENAME,POST_STARANK,POST_PRICE];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        sqlite3_bind_text(statment, 1, [post.postID UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 2, [post.username UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 3, [post.comment UTF8String],-1,NULL);
        sqlite3_bind_text(statment, 4, [post.linkToBuy UTF8String],-1,NULL);
        int i = [post.likes intValue];
        sqlite3_bind_int(statment, 5, i);
        sqlite3_bind_text(statment, 6, [post.imageName UTF8String],-1,NULL);
        int j = [post.starRank intValue];
        sqlite3_bind_int(statment, 7, j);
        sqlite3_bind_text(statment, 8, [post.price UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
    NSLog(@"Failed to execute saveNewPost - SQL");
}

//get posts from the sql table
+(NSArray*)getPostsToshow:(sqlite3*)database user:(NSString*)username{
    
    NSMutableArray* data = [[NSMutableArray alloc]init];
    sqlite3_stmt *statment;
    NSMutableArray* followers = [[NSMutableArray alloc]init];
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM FOLLOWINGFOLLOWERS WHERE Follower_USERNAME like '%@';",username];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        sqlite3_bind_text(statment, 1, [username UTF8String],-1,NULL);
    
        while(sqlite3_step(statment) == SQLITE_ROW){
            NSString* USERNAME = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
            NSString* follow = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
            NSLog(@"%@",USERNAME);
            NSLog(@"%@",follow);
            [followers addObject:follow];
        }
        
    }
    
    for(NSString* f in followers){
        NSString* queryFollow = [NSString stringWithFormat:@"SELECT * FROM POSTS WHERE POST_USERNAME like '%@';",f];
        if (sqlite3_prepare_v2(database,[queryFollow UTF8String],-1,&statment,nil)== SQLITE_OK){
            while(sqlite3_step(statment) == SQLITE_ROW){
                NSString* POSTID = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 0)];
                NSString* USERNAME = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
                NSString* COMMENT = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
                NSString* LINK = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 3)];
                NSNumber* LIKES= [NSNumber numberWithInt:(int)sqlite3_column_int(statment, 4)];
                NSString* IMAGENAME = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 5)];
                NSNumber* STARANK = [NSNumber numberWithInt:(int)sqlite3_column_int(statment, 6)];
                NSString* PRICE = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 7)];
                Post* post = [[Post alloc]init:PRICE comment:COMMENT linkToBuy:LINK likes:LIKES];
                post.postID = POSTID;
                post.username = USERNAME;
                post.imageName = IMAGENAME;
                post.starRank = STARANK;
                
                
                
                sqlite3_stmt *statment1;
                NSString* queryIkeOrNot = [NSString stringWithFormat:@"SELECT * FROM POSTSLIKESUSERS WHERE POSTSLIKESUSERS_POSTID like '%@' AND POSTSLIKESUSERS_POSTUSERNAME like '%@';",POSTID,username];
                if (sqlite3_prepare_v2(database,[queryIkeOrNot UTF8String],-1,&statment1,nil)== SQLITE_OK){
                    while(sqlite3_step(statment1) == SQLITE_ROW){
                    post.CurrentUserLikeThePostOrNot = YES;
                    }
                }
                [data addObject:post];
                
            }
        }
    }
    return data;
}






+(NSArray*)getAllPostsForUserProfile:(NSString*)username db:(sqlite3*)database{
    NSMutableArray* data = [[NSMutableArray alloc]init];
    //sqlite3_stmt *statment;
    //NSString* query = [NSString stringWithFormat:@"SELECT * FROM POSTS WHERE POST_USERNAME like '%@';",username];
   /* if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            Post* post = [[Post alloc]init];
            post.comment = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
            post.username = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
            post.imageName = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 5)];
            post.likes = [NSNumber numberWithInt:(int)sqlite3_column_int(statment, 4)];
            [data addObject:post];
        }
    }*/
    return data;
}



+(BOOL)UserLikePostOrNot:(Post*)postForLike current:current_user db:(sqlite3*)database{
    sqlite3_stmt *statment;
    
    if(postForLike.CurrentUserLikeThePostOrNot){
        NSString* createPostsLikesUsersID = [NSString stringWithFormat:@"%@%@", postForLike.postID,current_user];
        NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@ , %@ , %@) values (?,?,?);",POSTSLIKESUSERS_TABLE,POSTSLIKESUSERS_ID,POSTSLIKESUSERS_POSTID,POSTSLIKESUSERS_POSTUSERNAME];
        if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
            sqlite3_bind_text(statment, 1, [createPostsLikesUsersID UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [postForLike.postID UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 3, [current_user UTF8String],-1,NULL);
            if(sqlite3_step(statment) == SQLITE_DONE){
                return YES;
            }
        }
    }
    else {
        sqlite3_stmt *statment;
        NSString* query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE POSTSLIKESUSERS_POSTID like '%@' AND POSTSLIKESUSERS_POSTUSERNAME like '%@';",POSTSLIKESUSERS_TABLE, postForLike.postID, current_user];
        if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
            if(sqlite3_step(statment) == SQLITE_DONE){
                return YES;
            }
        }

 }
    return NO;
}

@end


