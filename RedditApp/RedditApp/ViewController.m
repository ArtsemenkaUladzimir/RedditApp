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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
