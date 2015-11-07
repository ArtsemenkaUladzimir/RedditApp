//
//  DetailsViewController.h
//  RedditApp
//
//  Created by Vladimir on 11/1/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#ifndef RedditApp_DetailsViewController_h
#define RedditApp_DetailsViewController_h

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSString *permalink;

@property (weak, nonatomic) IBOutlet UITextField *mainLabel;

@end

#endif
