//
//  StoreImage.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "StoreImage.h"

static id ObjectOrNull(id object)
{
    return object ?: [NSNull null];
}

@interface StoreImage ()

@property (nonatomic, retain) NSMutableDictionary *sharedStore;

@end

@implementation StoreImage

+ (StoreImage*) sharedStore {
    static StoreImage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[StoreImage alloc] init];
        sharedInstance.sharedStore = [[NSMutableDictionary alloc] initWithCapacity:20];
    });
    return sharedInstance;
}

- (void) setObject:(NSURL *)url image:(UIImage *)image {
    if (url != nil && image != nil) {
        [self.sharedStore setObject: ObjectOrNull(image) forKey:url];
    }
}

- (UIImage*) getObjectForKey:(NSURL *)url {
    return [self.sharedStore objectForKey:url];
}

@end