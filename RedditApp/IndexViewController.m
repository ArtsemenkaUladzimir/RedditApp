//
//  IndexViewController.m
//  RedditApp
//
//  Created by Vladimir on 10/2/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@property (nonatomic, retain) NSMutableData *jsonData;
@property (nonatomic, retain) NSMutableArray *listItem;

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listItem = [NSMutableArray new];
    [self complexDownload];
}

//////////////////////////////////// ToDo: Refactor //////////////////////////////////////
- (IBAction)complexDownload {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [NSURL URLWithString:@"https://www.reddit.com/hot.json"];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.jsonData = [NSMutableData data];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.jsonData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:self.jsonData options:NSJSONReadingMutableContainers error:nil];
    [[[JSON valueForKey:@"data"]valueForKey:@"children"]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
         [self.listItem addObject:[obj valueForKey:@"data"]];
     }];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"%@", [[JSON valueForKey:@"data"]valueForKey:@"children"]);
    [self.itemListTable reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
//////////////////////////////////// ToDo: End //////////////////////////////////////

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
        cell = [UITableViewCell new];
    }
    cell.textLabel.text = [[self.listItem objectAtIndex:indexPath.row]valueForKey:@"title"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[self.listItem objectAtIndex:indexPath.row]valueForKey:@"thumbnail"]]];
        if (data == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData: data];
//            [self.itemListTable beginUpdates];
//            [self.itemListTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self.itemListTable endUpdates];
        });
    });
    
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
