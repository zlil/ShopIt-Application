//
//  FollowingFollowersSql.h
//  Project
//
//  Created by Adi Azarya on 13/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FollowingFollowersSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(void)addFollowingRelation:(NSString*)username currenuser:(NSString*)user db:(sqlite3*)database key:(NSString*)uniqeFollowID;
+(void)deleteFollowingRelation2:(sqlite3*)database key:(NSString*)uniqeFollowID;


+(NSArray*)getNumberOfFollowersAndFollowings:(NSString*)username current:(NSString*)currentuser db:(sqlite3*)database;
@end
