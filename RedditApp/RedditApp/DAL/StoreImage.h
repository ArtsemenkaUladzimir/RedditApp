//
//  StoreImage.h
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#ifndef RedditApp_Header_h
#define RedditApp_Header_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StoreImage : NSObject

+ (id) sharedStore;
+ (void) setObject: (NSURL*)url image:(UIImage*)image;
+ (UIImage*) getObjectForKey: (NSString*)url;

@end

#endif
