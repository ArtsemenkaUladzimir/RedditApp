//
//  DownloadController.m
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadController.h"


@implementation APIDownload

@synthesize delegate;
@synthesize tag;
@synthesize downloadData;
@synthesize response;
@synthesize connection;

- (void)dealloc {
    self.downloadData = nil;
    self.response = nil;
    self.connection = nil;
}

+ (id)downloadWithURL:(NSString*)url delegate:(id)delegate sel:(SEL)selector {
    APIDownload *request = [APIDownload downloadWithURL:url delegate:delegate];
    [request setSuccessSelector:selector];
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [downloadData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([delegate respondsToSelector:successSelector]) {
        [delegate performSelector:successSelector withObject:self];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", error);
}

- (void)setSuccessSelector:(SEL)selector {
    successSelector = selector;
}

@end