//
//  Model.h
//  Project
//
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Post.h"
#import "Notifications.h"

@interface Model : NSObject{

}

@property NSString* current_username;

+(Model*)instance;

-(void)createNewUser:(NSString*)username password:(NSString*)password email:(NSString*)email block:(void(^)(BOOL))block;
-(void)loginUser:(NSString*)username password:(NSString *)password block:(void(^)(BOOL))block;
-(void)logout;
-(void)forgotpassword:(NSString*)email block:(void(^)(BOOL))block;
-(void)saveUserSettings:(NSString*)password email:(NSString *)email block:(void(^)(BOOL))block;
-(void)getPostsToshowAsynch:(void(^)(NSMutableArray*))block;
-(void)getUsersToshowInSearchAsynch:(void(^)(NSArray*))block;
-(void)getPostImage:(Post*)post block:(void(^)(UIImage*))block;
-(void)UserLikePostOrNot:(Post*)postForLike block:(void(^)(BOOL))block;
-(void)getAllPostsForUserProfile:(NSString*)username block:(void(^)(NSArray*))block;
-(void)getNumberOfFollowersAndFollowings:(NSString*)username currentUser:(NSString*)currentuser block:(void(^)(NSArray*))block;
-(void)saveNewPost:(Post*)post image:(UIImage*)image block:(void(^)(NSError*))block;
-(void)userToFollowOrUnfollow:(NSString*)username followOrNot:(NSString*)type block:(void(^)(BOOL))block;

//notification
-(void)getNotificationArray:(void(^)(NSArray*))block;
-(void)getNotificationImage:(Notifications*)notification block:(void(^)(UIImage*))block;
-(void)resetNotify:(NSString*)current_user;






@end
