//
//  NotificationSql.m
//  Project
//
//  Created by Adi Azarya on 12/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NotificationSql.h"
#import <sqlite3.h>

@implementation NotificationSql

//create the Notification tables for the first time
+(BOOL)createNotificationTable:(sqlite3*)database{
    
    
    
    char* errormsg;
    
    int res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS NOTIFICATIONS (TYPE TEXT, USERNAME TEXT, DID_USER TEXT, IMAGENAME TEXT)", NULL, NULL, &errormsg);
    
    if(res != SQLITE_OK){
        NSLog(@"ERROR: failed creating NOTIFICAIONS table");
        return NO;
    }
    NSLog(@"creating NOTIFICAIONS table succeed");
    return YES;
}

//save notifications to the table
+(void)saveNewNotification:(sqlite3*)database notifications:(NSArray*)notificationArr{
    
    sqlite3_stmt *statment = NULL;
    for (Notifications* n in notificationArr) {
        
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO NOTIFICATIONS (TYPE, USERNAME, DID_USER, IMAGENAME) VALUES (?,?,?,?);",-1,&statment,nil)== SQLITE_OK){
            sqlite3_bind_text(statment, 1, [n.type UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [n.CURRENTuserNotif UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 3, [n.userName UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 4, [n.notificationImageName UTF8String],-1,NULL);
        }
        
    }
    
    if(sqlite3_step(statment) == SQLITE_DONE){
        NSLog(@"new NOTIFICAIONS saved to the SQL table");
        //[NotificationSql getNotificationsToshow:database];
        return;
    }
    NSLog(@"Failed to execute saveNewNotification - SQL");
}


+(void)saveNewNotification2:(sqlite3*)database notifications:(Notifications*)notify {
    
    sqlite3_stmt *statment = NULL;
    if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO NOTIFICATIONS (TYPE, USERNAME, DID_USER, IMAGENAME) VALUES (?,?,?,?);",-1,&statment,nil)== SQLITE_OK){
            sqlite3_bind_text(statment, 1, [notify.type UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 2, [notify.CURRENTuserNotif UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 3, [notify.userName UTF8String],-1,NULL);
            sqlite3_bind_text(statment, 4, [notify.notificationImageName UTF8String],-1,NULL);
    }
    
    if(sqlite3_step(statment) == SQLITE_DONE){
        NSLog(@"new NOTIFICAIONS saved to the SQL table");
        //[NotificationSql getNotificationsToshow:database];
        return;
    }
    NSLog(@"Failed to execute saveNewNotification - SQL");
}

//get notifications from the sql table
+(NSArray*)getNotificationsToshow:(sqlite3*)database user:(NSString*)username{
    
    NSMutableArray* data = [[NSMutableArray alloc]init];
    sqlite3_stmt *statment;
    
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM NOTIFICATIONS WHERE USERNAME like '%@';",username];
    
    if (sqlite3_prepare_v2(database,[query UTF8String],-1,&statment,nil)== SQLITE_OK){
        sqlite3_bind_text(statment, 1, [username UTF8String],-1,NULL);
        
        while(sqlite3_step(statment) != SQLITE_DONE){
            NSString* type = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 0)];
            NSString* CURRENTuserNotif = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 1)];
            NSString* username = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 2)];
            NSString* imagename = [NSString stringWithFormat:@"%s",sqlite3_column_text(statment, 3)];
            
            //NSLog(@"Type %@ user %@ imagename %@",type , username ,imagename);
            
            Notifications* noti = [[Notifications alloc]init:type user:username ImageName:imagename userName:CURRENTuserNotif];
            [data addObject:noti];
        }
        
    }
    return data;
}



@end

