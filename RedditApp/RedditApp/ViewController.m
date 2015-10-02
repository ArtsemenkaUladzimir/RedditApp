//
//  ViewController.m
//  RedditApp
//
//  Created by Vladimir on 9/30/15.
//  Copyright (c) 2015 Vladimir. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textOutput;
@property (nonatomic, retain) NSMutableData *jsonData;

- (IBAction)easyDownload:(id)sender;

- (IBAction)complexDownload:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)easyDownload:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.reddit.com/hot.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.textOutput.text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (IBAction)complexDownload:(id)sender {
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
    self.textOutput.text = [[NSString alloc] initWithData:self.jsonData encoding:NSASCIIStringEncoding];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
