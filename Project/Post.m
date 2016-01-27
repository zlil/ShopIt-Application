//
//  Post.m
//  Project
//
//  Created by tomer aronovsky on 1/1/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import "Post.h"

@implementation Post


-(id)init:(NSString*)price comment:(NSString*)comment linkToBuy:(NSString*)linkToBuy likes:(NSNumber*)likes{
    self = [super init];
    if (self){
        _comment = comment;
        _price = price;
        _linkToBuy = linkToBuy;
        _likes = likes;
    }
    return self;
}

@end
