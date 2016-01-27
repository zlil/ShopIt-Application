//
//  ModelParse.h
//  Project
//
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Post.h"

@interface ModelParse : NSObject

//user methods
-(BOOL)createNewUser:(NSString*)usernamr password:(NSString*)password email:(NSString*)email;
-(BOOL)loginUser:(NSString*)username password:(NSString*)password;
-(void)logout;
-(BOOL)forgotPassword:(NSString*)email;
-(NSString*)getCurrentUser;
-(BOOL)saveUserSettings:(NSString*)password email:(NSString *)email;

//post methods
-(NSArray*)getPostsToshow;
-(UIImage*)getImage:(NSString*)imageName;

-(NSArray*)getStudentsToShowInSearch;
-(BOOL)UserLikePostOrNot:(Post*)post;
-(NSMutableArray*)getAllPostsForUserProfile:(NSString*)username;
-(NSArray*)getNumberOfFollowersAndFollowings:(NSString*)username;
-(void)saveNewPost:(Post*)post image:(UIImage*)image;
-(BOOL)userToFollowOrUnfollow:(NSString*)username followOrNot:(NSString*)type key:(NSString*)uniqePostID;


-(NSArray*)getPostFromDate:(NSString*)date postIds:(NSArray*)postIds;

-(NSArray*)getNotificationToShow;
-(NSArray*)getNotificationFromDate:(NSString*)date;

@end