//
//  IndexViewController.m
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "IndexViewController.h"
#import "DownloadManager.h"
#import "StoreImage.h"

@interface IndexViewController ()

@property (nonatomic, retain) NSMutableArray *listItem;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listItem = [[NSMutableArray alloc] init];
    [self loadWithURL:@"https://www.reddit.com/hot.json"];
}

- (void)loadWithURL: (NSString*)URL {
    NSURL *url = [NSURL URLWithString:URL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [DownloadManager loadDataWithUrl:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[[JSON valueForKey:@"data"]valueForKey:@"children"]
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             [self.listItem addObject:[obj valueForKey:@"data"]];
         }];
        [self.itemListTable reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [[self.listItem objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.listItem objectAtIndex:indexPath.row]valueForKey:@"thumbnail"]]];
    [DownloadManager loadDataWithUrl:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UITableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                if (updateCell) {
                    updateCell.imageView.image = image;
                }
            });
        }
    }];
    
    return cell;
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
