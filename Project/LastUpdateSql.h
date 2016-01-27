//
//  LastUpdateSql.h
//  Project
//
//  Created by Adi Azarya on 13/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface LastUpdateSql : NSObject

+(BOOL)createTable:(sqlite3*)database;
+(NSString*)getLastUpdateDate:(sqlite3*)database forTable:(NSString*)table;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date forTable:(NSString*)table;

@end
