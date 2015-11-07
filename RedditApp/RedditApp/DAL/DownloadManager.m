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

- (void) loadDataWithUrlMainThread:(NSURL *)URL completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    [[session dataTaskWithURL:URL completionHandler:completionHandler] resume];
}

- (void) loadImageWithUrl:(NSURL *)URL tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([URL absoluteString].length != 0) {
        if (![[StoreImage sharedStore]getObjectForKey:URL]) {
            [[DownloadManager sharedManager] loadDataWithUrlMainThread:URL completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    [[StoreImage sharedStore] setObject:URL image:image];
                    UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (updateCell) {
                        updateCell.imageView.image = image;
                        [updateCell setNeedsLayout];
                    }
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                if (updateCell) {
                    updateCell.imageView.image = [[StoreImage sharedStore]getObjectForKey:URL];
                    [updateCell setNeedsLayout];
                }
            });
        }
    }
}

- (void)dealloc {
}

@end