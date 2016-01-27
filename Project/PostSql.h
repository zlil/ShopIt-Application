//
//  PostSql.h
//  Project
//
//  Created by Adi Azarya on 11/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Post.h"
#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface PostSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(BOOL)createPostsLikeUsersTable:(sqlite3*)database;
+(void)saveNewPost:(Post*)post db:(sqlite3*)database;
+(NSArray*)getPostsToshow:(sqlite3*)database user:(NSString*)username;

+(NSArray*)getAllPostsForUserProfile:(NSString*)username db:(sqlite3*)database;
//+(NSString*)getLastUpdateDate:(sqlite3*)database;
//+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date;
//+(void)updatePost:(sqlite3*)database posts:(NSArray*)posts;


+(BOOL)UserLikePostOrNot:(Post*)postForLike current:(NSString*)current_user db:(sqlite3*)database;
@end
