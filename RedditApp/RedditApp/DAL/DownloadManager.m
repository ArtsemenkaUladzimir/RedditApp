//
//  DownloadManager.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//
#import "DownloadManager.h"
#import "StoreImage.h"

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

- (void) loadDataWithUrlMainThread:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithURL:url completionHandler:completionHandler] resume];
}

- (void) loadImageWithUrl:(NSURL *)url to:(UIImage*)image {
    if ([[StoreImage sharedStore]getObjectForKey:url]) {
        image = [[StoreImage sharedStore]getObjectForKey:url];
    } else {
        [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
            if (data) {
                UIImage *loadedImage = [UIImage imageWithData:data];
                [[StoreImage sharedStore] setObject:url image:loadedImage];
                image = [[StoreImage sharedStore]getObjectForKey:url];
            } else {
                image = [[StoreImage sharedStore]getDefault];
            }
        }];
    }
}

- (void)dealloc {
}

@end