//
//  DownloadManager.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//
#import "DownloadManager.h"

static DownloadManager *instance = nil;

@implementation DownloadManager

#pragma mark Singleton Methods

+ (id)getInstance {
    @synchronized(self) {
        if(instance == nil)
            instance = [self new];
    }
    return instance;
}

+ (void) loadData:(NSString*)URL completionHandler:(void (^)(NSData *data, NSURLResponse *responce, NSError *error))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:completionHandler];
}

- (void)dealloc {
}

@end