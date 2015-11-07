//
//  IndexViewController.m
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "IndexViewController.h"
#import "DetailsViewController.h"
#import "DownloadManager.h"
#import "StoreImage.h"
#import "MainController.h"

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
    [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[[JSON valueForKey:@"data"]valueForKey:@"children"]
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             [self.listItem addObject:[obj valueForKey:@"data"]];
         }];
        [self.tableView reloadData];
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
    cell.imageView.image = nil;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [[self.listItem objectAtIndex:indexPath.row]valueForKey:@"thumbnail"]]];
    
    [MainController loadImageWithUrl:url tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailsViewController *detailsViewController = segue.destinationViewController;
    detailsViewController.permalink = [[self.listItem objectAtIndex:indexPath.row] valueForKey:@"permalink"];
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
