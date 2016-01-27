//
//  Notifications.h
//  Project
//
//  Created by Adi Azarya on 06/01/2016.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Notifications : NSObject

@property NSString* type;
@property NSString* userName;
@property NSString* notificationImageName;
@property NSString* CURRENTuserNotif;

-(id)init:(NSString*)type user:(NSString*)userName ImageName:(NSString*)notificationImageName userName:(NSString*)CURRENTuserNotif;
@end
