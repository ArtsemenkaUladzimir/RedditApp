//
//  DownloadController.h
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//


// ToDo: Refactor
#ifndef RedditApp_DownloadController_h
#define RedditApp_DownloadController_h

#import <Foundation/Foundation.h>

@interface APIDownload : NSObject {
    SEL successSelector;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSURLResponse *response;
@property (nonatomic, retain) NSURLConnection *connection;

//+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector;
+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate;

- (void)setSuccessSelector:(SEL)selector;
- (void)cancel;

@end

#endif
