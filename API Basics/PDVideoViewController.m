//
//  PDVideoViewController.m
//  API Basics
//
//  Created by Lavrin on 5/31/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDVideoViewController.h"
#import "PDVideo.h"

@interface PDVideoViewController () <UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation PDVideoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
    self.navigationItem.title = self.video.name;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:self.video.videoPlayURL];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
}

#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) item {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
        
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
