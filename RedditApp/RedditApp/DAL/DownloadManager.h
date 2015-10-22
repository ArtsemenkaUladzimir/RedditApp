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

@interface DownloadManager : NSObject {
}

@property (nonatomic, retain) NSString *someProperty;

+ (id) getInstance;
+ (void) loadData:(NSString*)URL completionHandler:(void (^)(NSData *data, NSURLResponse *responce, NSError *error))completionHandler;

@end

#endif
