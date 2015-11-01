//
//  MainController.m
//  RedditApp
//
//  Created by Vladimir on 11/1/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "MainController.h"
#import "DownloadManager.h"
#import "StoreImage.h"

@implementation MainController

+ (void) loadImageWithUrl:(NSURL *)URL tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end