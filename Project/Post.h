//
//  Post.h
//  Project
//
//  Created by tomer aronovsky on 1/1/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property NSString* price;
@property NSString* comment;
@property NSString* linkToBuy;
@property NSString* username;
@property NSNumber* likes;
@property NSString* imageName;
@property BOOL CurrentUserLikeThePostOrNot;
@property NSNumber* starRank;
@property NSString* postID;
-(id)init:(NSString*)price comment:(NSString*)comment linkToBuy:(NSString*)linkToBuy likes:(NSNumber*)likes;

@end
