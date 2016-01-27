//
//  FollowingFollowersSql.m
//  Project
//
//  Created by Adi Azarya on 13/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "FollowingFollowersSql.h"

@implementation FollowingFollowersSql

static NSString* FOLLOWINGFOLLOWERS_TABLE = @"FOLLOWINGFOLLOWERS";
static NSString* UNIQEFOLLOW_ID = @"UNIQEFOLLOW_ID";
static NSString* Follower_USERNAME = @"Follower_USERNAME";
static NSString* FollowAfter_USERNAME = @"FollowAfter_USERNAME";

+(BOOL)createTable:(sqlite3*)database {
    char* errormsg;
    
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ TEXT PRIMARY KEY, %@ TEXT, %@ TEXT)",FOLLOWINGFOLLOWERS_TABLE,UNIQEFOLLOW_ID,Follower_USERNAME,FollowAfter_USERNAME];
    int res = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errormsg);
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating FOLLOWINGFOLLOWERS table");
        return NO;
    }
    return YES;
}




+(void)addFollowingRelation:(NSString*)username currenuser:(NSString*)user db:(sqlite3*)database key:(NSString*)uniqeFollowID{
        sqlite3_stmt *statment;
        NSString* query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@, %@ , %@ ) values (?,?,?);",FOLLOWINGFOLLOWERS_TABLE,UNIQEFOLLOW_ID,Follower_USERNAME,FollowAfter_USERNAME];
        
        if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
            sqlite3_bind_text(statment, 1, [uniqeFollowID UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [user UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 3, [username UTF8String],-1,NULL);
            if(sqlite3_step(statment) == SQLITE_DONE){
                return;
            }
        }
        NSLog(@"Failed to execute addFollowingRelation - SQL");
}


+(void)deleteFollowingRelation2:(sqlite3*)database key:(NSString*)uniqeFollowID{
    sqlite3_stmt *statment;
    NSString* query = [NSString stringWithFormat:@"DELETE FROM FOLLOWINGFOLLOWERS WHERE UNIQEFOLLOW_ID like '%@';",uniqeFollowID];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        //sqlite3_bind_text(statment, 1, [user UTF8String],-1,NULL);
        //sqlite3_bind_text(statment, 2, [username UTF8String],-1,NULL);
        if(sqlite3_step(statment) == SQLITE_DONE){
            return;
        }
    }
}



+(NSArray*)getNumberOfFollowersAndFollowings:(NSString*)username current:(NSString*)currentuser db:(sqlite3*)database{
    sqlite3_stmt *statment;
    int followings=0;
    int followers=0;
    int alreadyFollow = 0;
    
    NSString* query = [NSString stringWithFormat:@"Select * From %@ WHERE Follower_USERNAME like '%@';",FOLLOWINGFOLLOWERS_TABLE,username];
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            followings++;
        }
    }
    query = [NSString stringWithFormat:@"Select * From %@ WHERE FollowAfter_USERNAME like '%@';",FOLLOWINGFOLLOWERS_TABLE,username];
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            followers++;
        }
    }
    
    query = [NSString stringWithFormat:@"Select * From %@ WHERE FollowAfter_USERNAME like '%@' AND Follower_USERNAME like '%@';",FOLLOWINGFOLLOWERS_TABLE,username,currentuser];
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        while(sqlite3_step(statment) == SQLITE_ROW){
            alreadyFollow=1;
        }
    }

    NSMutableArray* arr = [[NSMutableArray alloc]init];
    [arr addObject:[NSNumber numberWithInt:followers]];
    [arr addObject:[NSNumber numberWithInt:followings]];
    [arr addObject:[NSNumber numberWithInt:alreadyFollow]];
    
    return arr;
}



@end
