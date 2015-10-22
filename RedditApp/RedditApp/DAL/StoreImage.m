//
//  StoreImage.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "StoreImage.h"

@interface StoreImage ()

@property (nonatomic, retain) NSMutableDictionary *sharedStore;

@end

@implementation StoreImage

+ (id) sharedStore {
    static StoreImage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StoreImage alloc] init];
        sharedInstance.sharedStore = [[NSMutableDictionary alloc] init];
    });
    return sharedInstance;
}

+ (void) setObject:(NSString *)url image:(UIImage *)image {
    [self.sharedStore setObject: url forKey:image];
}

+ (UIImage*) getObjectForKey:(NSString *)url {
    return [self.sharedStore objectForKey:url];
}

@end