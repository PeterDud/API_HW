//
//  PDMessageViewController.m
//  API Basics
//
//  Created by Lavrin on 5/25/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDMessageViewController.h"
#import "PDServerManager.h"
#import "PDCommentTVC.h"

@interface PDMessageViewController ()

@end

@implementation PDMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PDCommentTVC *commentTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDCommentTVC"];
    
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

- (IBAction)sendClicked:(UIButton *)sender {
    
    if (self.userID) {
        
        [[PDServerManager sharedManager]
         sendMessage:self.enteredText.text
         toUser:self.userID
         onSuccess:^(id result) {
             
         } onFailure:^(NSError *error, NSInteger statusCode) {
             
         }];
    } else if (self.postID) {
        
        [[PDServerManager sharedManager]
         commentText:self.enteredText.text
         toPost:self.postID
         onSuccess:^(id result) {
             
             
         } onFailure:^(NSError *error, NSInteger statusCode) {
             
             
         }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}












@end
