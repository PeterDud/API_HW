//
//  PDProfileViewController.m
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDProfileViewController.h"
#import "PDViewController.h"
#import "PDWallViewController.h"

@interface PDProfileViewController ()

@end

@implementation PDProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 1) {
        
        PDViewController *followersVC = [[PDViewController alloc] init];
        
        followersVC.userID = self.follower.userID;
        [followersVC view];

        [self.navigationController pushViewController:followersVC animated:YES];
    
    } else if (indexPath.row == 2) {
        
        PDViewController *subscriptionsVC = [[PDViewController alloc] init];
        
        subscriptionsVC.userID = self.follower.userID;
        subscriptionsVC.isSubscriptionsList = YES;
        
        [self.navigationController pushViewController:subscriptionsVC animated:YES];
    
    } else if (indexPath.row == 3) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PDWallViewController *postsVC = [storyboard instantiateViewControllerWithIdentifier:@"PDWallViewController"];
                
        postsVC.userID = self.follower.userID;
        
        [self.navigationController pushViewController:postsVC animated:YES];
    }
    
}








@end
