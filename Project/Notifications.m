//
//  Notifications.m
//  Project
//
//  Created by Adi Azarya on 06/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "Notifications.h"

@implementation Notifications

-(id)init:(NSString*)type user:(NSString*)userName ImageName:(NSString*)notificationImageName userName:(NSString*)CURRENTuserNotif{
    self = [super init];
    if(self){
        _type = type;
        _userName = userName;
        _notificationImageName = notificationImageName;
        _CURRENTuserNotif = CURRENTuserNotif;
    }
    return self;
}


@end
