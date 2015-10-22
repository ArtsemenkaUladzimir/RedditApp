//
//  StoreImage.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "StoreImage.h"

@interface StoreImage ()

@end

@implementation StoreImage

+ (id) sharedStore {
    static StoreImage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StoreImage alloc] init];
    });
    return sharedInstance;
}

+ (void) push: (UIImage*)image {
    
}

@end