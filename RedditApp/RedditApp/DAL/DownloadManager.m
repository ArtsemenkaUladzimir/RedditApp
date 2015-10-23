//
//  DownloadManager.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//
#import "DownloadManager.h"

@implementation DownloadManager

+ (DownloadManager*)sharedManager {
    static DownloadManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadManager alloc] init];
    });
    return sharedInstance;

}

- (void) loadDataWithUrl:(NSURL *)URL completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:completionHandler];
    [dataTask resume];
}

- (void)dealloc {
}

@end