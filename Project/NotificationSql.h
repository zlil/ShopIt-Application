//
//  NotificationSql.h
//  Project
//
//  Created by Adi Azarya on 12/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notifications.h"
#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface NotificationSql : NSObject

+(BOOL)createNotificationTable:(sqlite3*)database;
+(void)saveNewNotification:(sqlite3*)database notifications:(NSArray*)notiArr;
+(NSArray*)getNotificationsToshow:(sqlite3*)database user:(NSString*)username;
+(void)saveNewNotification2:(sqlite3*)database notifications:(Notifications*)notify;

@end