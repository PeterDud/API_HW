//
//  PDStartViewController.m
//  API Basics
//
//  Created by Lavrin on 5/25/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDStartViewController.h"
#import "PDWallViewController.h"

#import "PDServerManager.h"
#import "PDUser.h"

@interface PDStartViewController ()

@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation PDStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstTimeAppear = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.firstTimeAppear) {
        
        self.firstTimeAppear = NO;
        
        [[PDServerManager sharedManager] authorizeUser:^(PDUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
        }];
    }
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

#pragma mark - Actions

- (IBAction)iOSDevCourseClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PDWallViewController *wallVC =
                    [storyboard  instantiateViewControllerWithIdentifier:@"PDWallViewController"];
    
    [self.navigationController pushViewController:wallVC animated:YES];
}


@end
