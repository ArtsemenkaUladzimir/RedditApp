//
//  DownloadManager.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//
#import "DownloadManager.h"

@implementation DownloadManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static DownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadManager alloc] init];
    });
    return sharedInstance;

}

+ (void) loadData:(NSString*)URL completionHandler:(void (^)(NSData *data, NSURLResponse *responce, NSError *error))completionHandler {
    NSURLSession *session = [NSURLSession sharedSession];
    [session dataTaskWithURL:[NSURL URLWithString:URL] completionHandler:completionHandler];
}

- (void)dealloc {
}

@end