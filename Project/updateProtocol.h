//
//  updateProtocol.h
//  Project
//
//  Created by Adi Azarya on 14/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface updateProtocol : NSObject

+(NSString*)getLastUpdateDate:(sqlite3*)database tableType:(NSString*)TABLE;
+(void)updateTable:(sqlite3 *)database Objects:(NSArray *)object table:(NSString*)TABLE;
+(void)setLastUpdateDate:(sqlite3*)database date:(NSString*)date table:(NSString*)TABLE;
@end
