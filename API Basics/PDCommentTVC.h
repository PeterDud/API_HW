//
//  PDCommentTVC.h
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessageViewController.h"
#import "PDPostViewCell.h"

@class PDPost;

@interface PDCommentTVC : UITableViewController <PDPostViewCellDelegate>

@property (strong, nonatomic) NSString *postID;
@property (strong, nonatomic) PDPost *post;

-(void) getCommentsFromServer;

@end
