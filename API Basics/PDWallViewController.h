//
//  PDPostsViewController.h
//  API Basics
//
//  Created by Lavrin on 5/18/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDWallViewController : UITableViewController

@property (strong, nonatomic) NSString *userID;

- (IBAction)addClicked:(id)sender;
- (IBAction)myMessagesClicked:(UIBarButtonItem *)sender;

@end
