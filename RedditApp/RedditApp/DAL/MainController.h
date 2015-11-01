//
//  MainController.h
//  RedditApp
//
//  Created by Vladimir on 11/1/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#ifndef RedditApp_MainController_h
#define RedditApp_MainController_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MainController : NSObject

+ (void) loadImageWithUrl:(NSURL *)URL tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#endif
