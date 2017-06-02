//
//  PDPostingVCViewController.m
//  API Basics
//
//  Created by Lavrin on 5/23/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPostingViewController.h"
#import "PDServerManager.h"

@interface PDPostingViewController ()

@end

@implementation PDPostingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Write a Post";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)postClicked:(UIButton *)sender {
    
    [[PDServerManager sharedManager]
     postText:self.enteredText.text
     onGroupWall:@"58860049"
     onSuccess:^(id result) {
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
     }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}









@end









