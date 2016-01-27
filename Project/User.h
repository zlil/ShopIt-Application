//
//  User.h
//  Project
//
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property NSString* username;
@property NSString* password;
@property NSString* email;

-(id)init:(NSString*)username password:(NSString*)password email:(NSString*)email;


@end
