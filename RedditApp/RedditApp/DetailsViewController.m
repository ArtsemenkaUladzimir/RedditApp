//
//  DetailsViewController.m
//  RedditApp
//
//  Created by Vladimir on 11/1/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "DetailsViewController.h"
#import "DownloadManager.h"
#import "StoreImage.h"
#import "DetailsCollectionViewCell.h"

@interface DetailsViewController ()

@property (nonatomic, retain) NSDictionary *item;
@property (nonatomic, retain) NSMutableArray *details;

@end

@implementation DetailsViewController

@synthesize mainLabel;
@synthesize permalink;
@synthesize mainThumbnail;
@synthesize detailsCollectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWithURL:[NSString stringWithFormat:@"https://www.reddit.com%@.json", permalink]];
    
    [self.detailsCollectionView reloadData];
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
                 self.item = [obj valueForKey:@"data"];
                 [self initDetails];
             }];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }];
}

- (void) initDetails {
    self.mainLabel.text = [self.item valueForKey:@"title"];
    
    self.details = [NSMutableArray new];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"score", @"key", [[self.item valueForKey:@"score"]stringValue], @"value", nil]];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"author", @"key", [self.item valueForKey:@"author"], @"value", nil]];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"subreddit", @"key", [self.item valueForKey:@"subreddit"], @"value", nil]];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"num_comments", @"key", [[self.item valueForKey:@"num_comments"]stringValue], @"value", nil]];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"domain", @"key", [self.item valueForKey:@"domain"], @"value", nil]];
    [self.details addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"over_18", @"key", [[self.item valueForKey:@"over_18"]stringValue], @"value", nil]];
    
    @try {
        [self.detailsCollectionView reloadData];
    }
    @catch (NSException *exception) {}
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.item valueForKey:@"thumbnail"]]];
    
    if ([url absoluteString].length != 0) {
        if ([[StoreImage sharedStore]getObjectForKey:url]) {
            self.mainThumbnail.image = [[StoreImage sharedStore]getObjectForKey:url];
        } else {
            [[DownloadManager sharedManager] loadDataWithUrlMainThread:url completionHandler:^(NSData *data, NSURLResponse *responce, NSError *error) {
                if (data) {
                    UIImage *loadedImage = [UIImage imageWithData:data];
                    [[StoreImage sharedStore] setObject:url image:loadedImage];
                    self.mainThumbnail.image = [[StoreImage sharedStore]getObjectForKey:url];
                } else {
                    self.mainThumbnail.image = [[StoreImage sharedStore]getDefault];
                }
            }];
        }
    } else {
        self.mainThumbnail.image = [[StoreImage sharedStore] getDefault];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    DetailsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.title.text = [[self.details objectAtIndex:indexPath.row]objectForKey:@"key"];
    cell.label.text = [[self.details objectAtIndex:indexPath.row]objectForKey:@"value"];
    
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
