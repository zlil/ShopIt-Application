//
//  Model.m
//  Project
//
//  Created by tomer aronovsky on 12/24/15.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "Model.h"
#import "ModelParse.h"
#import "ModelSQL.h"
#import "LastUpdateSql.h"
#import "User.h"

@implementation Model {
    ModelParse* parseModelImpl;
    ModelSQL* sqlModelImpl;
}


static Model* instance = nil;

+(Model*)instance{
    @synchronized(self){
        if (instance == nil) {
            instance = [[Model alloc] init];
        }
    }
    return instance;
}

-(id)init{
    self = [super init];
    if (self) {
        sqlModelImpl = [[ModelSQL alloc]init];
        parseModelImpl = [[ModelParse alloc] init];
        _current_username = [parseModelImpl getCurrentUser];
    }
    return self;
}


// ------------- sign up ----------- //
-(void)createNewUser:(NSString*)username password:(NSString *)password email:(NSString *)email block:(void(^)(BOOL))block{
    
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl createNewUser:username password:password email:email];
        if(res)
            self.current_username = username;
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );
}


// ------------- login & logout ----------- //
-(void)loginUser:(NSString*)username password:(NSString *)password block:(void(^)(BOOL))block{
    dispatch_queue_t myQueue =  dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        BOOL res = [parseModelImpl loginUser:username password:password];
        if(res){
            self.current_username = username;
        }
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    });
}


-(void)logout{
    [parseModelImpl logout];
    _current_username = nil;
}


// ------------- forgot user password ----------- //
-(void)forgotpassword:(NSString*)email block:(void(^)(BOOL))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //long operation
        BOOL res = [parseModelImpl forgotPassword:email];
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    } );

}

// ------------- current user ----------- //
-(void)getCurrentUser:(void(^)(User*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        NSString* res = [parseModelImpl getCurrentUser];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    });
}




// ------------- save user setting----------- //
-(void)saveUserSettings:(NSString*)password email:(NSString *)email block:(void(^)(BOOL))block{
    dispatch_queue_t myQueue =  dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        BOOL res = [parseModelImpl saveUserSettings:password email:email];
        
        if(YES){
            NSLog(@"succesfull save settings");
        }
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(res);
        });
    });

}


// ------------- posts functions ----------- //
-(void)getPostsToshowAsynch:(void(^)(NSMutableArray*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
        NSMutableArray* posts = [[NSMutableArray alloc]init];
        //NSArray* array = [[NSArray alloc]init];
        NSString* lastUpdate = [sqlModelImpl getLastUpdateDate:@"Post"];
        //NSMutableArray* updatedData = [[NSMutableArray alloc]init];
        NSMutableArray* updatedData = nil;
        if(lastUpdate != nil){
            
            //posts = (NSMutableArray*)[sqlModelImpl getPostsToshow:self.current_username];
            NSArray* ArrayPost = [parseModelImpl getPostFromDate:lastUpdate postIds:(NSArray*)posts];
            updatedData = (NSMutableArray*)ArrayPost;
            
            if(updatedData.count == 0){
                NSArray* ArrayPost = [sqlModelImpl getPostsToshow:self.current_username];
                posts =(NSMutableArray*)ArrayPost;
                //posts = (NSMutableArray*)[sqlModelImpl getPostsToshow:self.current_username];
            }
        }
        else{
            NSArray* queryArrayPosts = (NSMutableArray*)[parseModelImpl getPostsToshow];
            updatedData = (NSMutableArray*)queryArrayPosts;
        }
        if(updatedData.count > 0){
            [sqlModelImpl update:updatedData table:@"Post"];
            [sqlModelImpl setLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] table:@"Post"];
            posts = (NSMutableArray*)[sqlModelImpl getPostsToshow:self.current_username];
        }
        
        
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(posts);
        });
    });
}


-(void)getPostImage:(Post*)post block:(void(^)(UIImage*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
        //first try to get the image from local file
        UIImage* image = [self readingImageFromFile:post.imageName];
        
        if(image == nil){
            image = [parseModelImpl getImage:post.imageName];
            //one the image is loaded save it localy
            if(image != nil){
                [self savingImageToFile:image fileName:post.imageName];
            }
        }
       dispatch_queue_t mainQ = dispatch_get_main_queue();
       dispatch_async(mainQ, ^{
        block(image);
    });
    });
}


-(void)UserLikePostOrNot:(Post*)postForLike block:(void(^)(BOOL))block{
    
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
        //add or remove the likes from sql&parse
        BOOL post = [parseModelImpl UserLikePostOrNot:postForLike];
        BOOL postLikeOrNotSQL = [sqlModelImpl UserLikePostOrNot:postForLike current:self.current_username];

        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(postLikeOrNotSQL);
        });
    });

}





-(void)getAllPostsForUserProfile:(NSString*)username block:(void(^)(NSArray*))block {
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        NSMutableArray* posts = [parseModelImpl getAllPostsForUserProfile:username];
        
        
        //NSArray* postsSQL = [sqlModelImpl getAllPostsForUserProfile:username];
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(posts);
        });
    });

}


-(void)getNumberOfFollowersAndFollowings:(NSString*)username currentUser:(NSString*)currentuser block:(void(^)(NSArray*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        //NSArray* followersFollowings = [parseModelImpl getNumberOfFollowersAndFollowings:username];
        
        NSArray* followersFollowingsFromSQL = [sqlModelImpl getNumberOfFollowersAndFollowings:username current:currentuser];
        
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(followersFollowingsFromSQL);
        });
    });
}

-(void)saveNewPost:(Post*)post image:(UIImage*)image block:(void(^)(NSError*))block {
    dispatch_queue_t myQueue =  dispatch_queue_create("myQueueName", NULL);
    
    dispatch_async(myQueue, ^{
        //save new post
        [parseModelImpl saveNewPost:post image:image];
        [sqlModelImpl saveNewPost:post image:image];
        //save the image post localy
        [self savingImageToFile:image fileName:post.imageName];
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(nil);
        });
    });
}


//------------end posts functions--------------//



// ------------- search functions ----------- //
-(void)getUsersToshowInSearchAsynch:(void(^)(NSArray*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        NSMutableArray* students = (NSMutableArray*)[parseModelImpl getStudentsToShowInSearch];
        
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(students);
        });
    });
    
}




-(void)userToFollowOrUnfollow:(NSString*)username followOrNot:(NSString*)type block:(void(^)(BOOL))block{
    
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
       // long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
       // NSString *currentTimeToSend = [NSString stringWithFormat:@"%ld", currentTime];
        
        NSString* uniqeFollowID = [NSString stringWithFormat:@"%@%@",self.current_username,username];
        
        
        BOOL followOrUnfollow = [parseModelImpl userToFollowOrUnfollow:username followOrNot:type key:uniqeFollowID];
        //sql
        [sqlModelImpl SetfollowersTableSQL:username user:self.current_username followOrNot:type key:uniqeFollowID];
        //end of long operation - update display in the main Q
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(followOrUnfollow);
        });
    });
   
}



-(void)resetNotify:(NSString*)current_user{
    [sqlModelImpl resetNotify:self.current_username];
}


//notification

//-(void)getNotificationArray:(void(^)(NSArray*))block{
//    dispatch_queue_t myQueue = dispatch_queue_create("myQueueName", NULL);
//    dispatch_async(myQueue, ^{
//        
//        //NSArray* array = [modelImpl getNotificationObject];
//        
//        //SQL
//        NSMutableArray* NotificationsArr = (NSMutableArray*)[sqlModelImpl getNotificationsToshow:self.current_username];
//        NSString* lastUpdate = [sqlModelImpl getLastUpdateDate:@"Notification"];
//        NSMutableArray* updatedData;
//        if(lastUpdate != nil){
//            NSLog(@"last update != nil");
//            updatedData = (NSMutableArray*)[parseModelImpl getNotificationFromDate:lastUpdate];
//            //if(updatedData.count > 0) //will update SQL table.
//            //[sqlModelImpl setNotificationObject:[parseModelImpl getNotificationFromDate:lastUpdate]];
//        }
//        else{
//            NSLog(@"last update == nil");
//            updatedData = (NSMutableArray*)[parseModelImpl getNotificationToShow];
//        }
//        if(updatedData.count > 0){
//            [sqlModelImpl update:updatedData table:@"Notification"];
//            [sqlModelImpl setLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] table:@"Notification"];
//            NotificationsArr = (NSMutableArray*)[sqlModelImpl getNotificationsToshow:self.current_username];
//        }
//        
//        dispatch_queue_t mainQ = dispatch_get_main_queue();
//        dispatch_async(mainQ, ^{
//            block(NotificationsArr);
//        });
//    });
//    
//}

        
-(void)getNotificationArray:(void(^)(NSArray*))block{
    dispatch_queue_t myQueue = dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
        NSArray* array = [[NSMutableArray alloc]init];
        
        //SQL
        //NSMutableArray* NotificationsArr = (NSMutableArray*)[sqlModelImpl getNotificationsToshow:self.current_username];
        NSString* lastUpdate = [sqlModelImpl getLastUpdateDate:@"Notification"];
        NSMutableArray* updatedData;
        if(lastUpdate != nil){
            NSLog(@"last update != nil");
            NSArray* ArrayPost = [parseModelImpl getNotificationFromDate:lastUpdate];
            updatedData = (NSMutableArray*)ArrayPost;
            if(updatedData.count == 0){
                array = (NSMutableArray*)[sqlModelImpl getNotificationsToshow:self.current_username];
            }
           
        }
        else{
            NSLog(@"last update == nil");
            NSArray* queryArrayPosts = [parseModelImpl getNotificationToShow];
            updatedData = (NSMutableArray*)queryArrayPosts;
        }
        if(updatedData.count > 0){
            [sqlModelImpl update:updatedData table:@"Notification"];
            [sqlModelImpl setLastUpdateDate:[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]] table:@"Notification"];
            array = (NSMutableArray*)[sqlModelImpl getNotificationsToshow:self.current_username];
        }
        
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(array);
        });
    });
    
}



-(void)getNotificationImage:(Notifications*)notification block:(void(^)(UIImage*))block{
    dispatch_queue_t myQueue =    dispatch_queue_create("myQueueName", NULL);
    dispatch_async(myQueue, ^{
        
        //first try to get the image from local file
        UIImage* image = [self readingImageFromFile:notification.notificationImageName];
        
        if(image == nil){
            image = [parseModelImpl getImage:notification.notificationImageName];
            //once the image is loaded save it localy
            if(image != nil){
                [self savingImageToFile:image fileName:notification.notificationImageName];
            }
        }
        dispatch_queue_t mainQ = dispatch_get_main_queue();
        dispatch_async(mainQ, ^{
            block(image);
        });
    });
}


// Working with local files
-(void)savingImageToFile:(UIImage*)image fileName:(NSString*)fileName{
    NSData *pngData = UIImagePNGRepresentation(image);
    [self saveToFile:pngData fileName:fileName];
}

-(UIImage*)readingImageFromFile:(NSString*)fileName{
    NSData* pngData = [self readFromFile:fileName];
    if (pngData == nil) return nil;
    return [UIImage imageWithData:pngData];
}


-(NSString*)getLocalFilePath:(NSString*)fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return filePath;
}

-(void)saveToFile:(NSData*)data fileName:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    [data writeToFile:filePath atomically:YES]; //Write the file
}

-(NSData*)readFromFile:(NSString*)fileName{
    NSString* filePath = [self getLocalFilePath:fileName];
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    return pngData;
}










@end
