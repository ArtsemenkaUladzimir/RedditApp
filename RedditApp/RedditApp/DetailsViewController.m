//
//  DetailsViewController.m
//  RedditApp
//
//  Created by Vladimir on 11/1/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "DetailsViewController.h"
#import "DownloadManager.h"

@interface DetailsViewController ()

@property (nonatomic, retain) NSObject *item;
@property (nonatomic, retain) NSMutableArray *comments;

@end

@implementation DetailsViewController

@synthesize mainLabel;
@synthesize permalink;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWithURL:[NSString stringWithFormat:@"https://www.reddit.com%@.json", permalink]];
}

- (void)loadWithURL: (NSString*)URL {
    NSURL *url = [NSURL URLWithString:URL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
        id JSONObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        if ([JSONObj isKindOfClass:[NSArray class]]) {
            NSArray *JSON = JSONObj;
            self.item = [[[[[JSON firstObject] valueForKey:@"data"]valueForKey:@"children"] firstObject]valueForKey:@"data"];
            [[[[JSON firstObject] valueForKey:@"data"]valueForKey:@"children"]
             enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 self.mainLabel.text = [[obj valueForKey:@"data"] valueForKey:@"title"];
             }];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
