//
//  PDMessageViewController.h
//  API Basics
//
//  Created by Lavrin on 5/25/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDCommentTVC.h"

@protocol PDMessageViewControllerDelegate;

@interface PDMessageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *enteredText;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *postID;

@property (weak, nonatomic) id <PDMessageViewControllerDelegate> delegate;

- (IBAction)sendClicked:(UIButton *)sender;
- (IBAction)cancelClicked:(id)sender;

@end


@protocol PDMessageViewControllerDelegate <NSObject>

- (void) addMyCommentToTableView;

@end