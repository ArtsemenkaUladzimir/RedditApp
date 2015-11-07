//
//  DownloadManager.h
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#ifndef RedditApp_DownloadManager_h
#define RedditApp_DownloadManager_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DownloadManager : NSObject

+ (DownloadManager*) sharedManager;

- (void) loadImageWithUrl:(NSURL *)URL tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) loadDataWithUrl:(NSURL *)URL completionHandler:(void (^)(NSData *data, NSURLResponse *responce, NSError *error))completionHandler;

- (void) loadDataWithUrlMainThread:(NSURL *)URL completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler;


@end

#endif
