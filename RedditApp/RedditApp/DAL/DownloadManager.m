//
//  DownloadManager.m
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//
#import "DownloadManager.h"
#import "StoreImage.h"
#import "IndexViewCell.h"

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

- (void) loadImageWithUrl:(NSURL *)url to:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IndexViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[StoreImage sharedStore]getObjectForKey:url]) {
        updateCell.posterImageView.image = [[StoreImage sharedStore]getObjectForKey:url];
    } else {
        [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
            IndexViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
            if (data) {
                UIImage *loadedImage = [UIImage imageWithData:data];
                [[StoreImage sharedStore] setObject:url image:loadedImage];
                updateCell.posterImageView.image = [[StoreImage sharedStore]getObjectForKey:url];
            } else {
                updateCell.posterImageView.image = [[StoreImage sharedStore]getDefault];
            }
        }];
    }
}

- (void)dealloc {
}

@end