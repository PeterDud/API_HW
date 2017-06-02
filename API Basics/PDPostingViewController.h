//
//  PDPostingVCViewController.h
//  API Basics
//
//  Created by Lavrin on 5/23/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDPostingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *enteredText;

- (IBAction)postClicked:(UIButton *)sender;
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;

@end
