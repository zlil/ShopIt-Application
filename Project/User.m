//
//  User.m
//  Project
//
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "User.h"

@implementation User

-(id)init:(NSString*)username password:(NSString*)password email:(NSString*)email {
    self = [super init];
    if (self){
        _username = username;
        _password = password;
        _email = email;
    }
    return self;
}
@end
