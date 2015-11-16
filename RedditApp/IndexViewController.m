//
//  IndexViewController.m
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexViewCell.h"
#import "DetailsViewController.h"
#import "DownloadManager.h"
#import "StoreImage.h"

@interface IndexViewController ()

@property (nonatomic, retain) NSMutableArray *item;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.item = [[NSMutableArray alloc] init];
    [self loadWithURL:@"https://www.reddit.com/hot.json"];
}

- (void)loadWithURL: (NSString*)URL {
    NSURL *url = [NSURL URLWithString:URL];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[[JSON valueForKey:@"data"]valueForKey:@"children"]
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             [self.item addObject:[obj valueForKey:@"data"]];
         }];
        [self.tableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.item count];
}

- (IndexViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IndexViewCell";
    
    IndexViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[IndexViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IndexViewCell"];
    }
    cell.textLabel.text = [[self.item objectAtIndex:indexPath.row]valueForKey:@"title"];
    cell.detailTextLabel.text = [[self.item objectAtIndex:indexPath.row]valueForKey:@"subreddit"];
    cell.posterImageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.item objectAtIndex:indexPath.row]valueForKey:@"thumbnail"]]];
    
    if ([url absoluteString].length != 0) {
        if ([[StoreImage sharedStore]getObjectForKey:url]) {
            cell.posterImageView.image = [[StoreImage sharedStore]getObjectForKey:url];
        } else {
            [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
                IndexViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                if (data) {
                    UIImage *loadedImage = [UIImage imageWithData:data];
                    [[StoreImage sharedStore] setObject:url image:loadedImage];
                    updateCell.posterImageView.image = [[StoreImage sharedStore]getObjectForKey:url];
                } else {
                    updateCell.posterImageView.image = [[StoreImage sharedStore]getDefault];
                }
            }];
        }
    } else {
        cell.posterImageView.image = [[StoreImage sharedStore] getDefault];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailsViewController *detailsViewController = segue.destinationViewController;
    detailsViewController.permalink = [[self.item objectAtIndex:indexPath.row] valueForKey:@"permalink"];
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
