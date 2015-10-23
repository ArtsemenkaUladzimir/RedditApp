//
//  StoreImage.h
//  RedditApp
//
//  Created by Vladimir on 10/22/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#ifndef RedditApp_StoreImage_h
#define RedditApp_StoreImage_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StoreImage : NSObject

+ (StoreImage*) sharedStore;
- (void) setObject: (NSURL*)url image:(UIImage*)image;
- (UIImage*) getObjectForKey: (NSURL*)url;

@end

#endif
