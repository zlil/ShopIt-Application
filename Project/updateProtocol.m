//
//  updateProtocol.m
//  Project
//
//  Created by Adi Azarya on 14/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "updateProtocol.h"
#import "LastUpdateSql.h"
#import "Post.h"
#import "PostSql.h"
#import "NotificationSql.h"
#import "FollowingFollowersSql.h"

@implementation updateProtocol
+(NSString*)getLastUpdateDate:(sqlite3*)database tableType:(NSString*)TABLE{
    return [LastUpdateSql getLastUpdateDate:database forTable:TABLE];
}

+(void)updateTable:(sqlite3 *)database Objects:(NSArray *)object table:(NSString*)TABLE{
  
    if ([TABLE  isEqual: @"POSTS"]){
        for (Post* p in object) {
            [PostSql saveNewPost:p db:database];
        }
    }
    else if ([TABLE  isEqual: @"NOTIFICATIONS"])
        //[NotificationSql saveNewNotification:database notifications:object];
    {
        for(Notifications* n in object){
            [NotificationSql saveNewNotification2:database notifications:n];
        }
    }
        
    else
        NSLog (@"error updateTable query - updataProtocol");
}

+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date table:(NSString*)TABLE{
    [LastUpdateSql setLastUpdateDate:database date:date forTable:TABLE];
}
@end
