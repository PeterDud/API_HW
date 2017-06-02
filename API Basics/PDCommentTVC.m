//
//  PDCommentTVC.m
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDCommentTVC.h"
#import "PDMessageViewController.h"
#import "PDServerManager.h"
#import "PDMessageViewCell.h"
#import "PDPostViewCell.h"
#import "PDCommentsCountViewCell.h"

#import "UIImageView+AFNetworking.h"

#import "PDPost.h"
#import "PDComment.h"

@interface PDCommentTVC ()

@property (strong, nonatomic) NSMutableArray *commentsArray;
@property (assign, nonatomic) BOOL firstTimeAppear;
@property (assign, nonatomic) BOOL needToAddComment;
@property (assign, nonatomic) BOOL isLiked;

@end

@implementation PDCommentTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Post";
    
    self.firstTimeAppear = YES;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.firstTimeAppear) {
        self.firstTimeAppear = NO;
        
        self.commentsArray = [NSMutableArray array];
        [self getCommentsFromServer];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.needToAddComment) {
        
        [self addMyCommentToTableView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void) getCommentsFromServer {

    [[PDServerManager sharedManager]
     getCommentsOfPost:self.postID
     OfOwner:@"-58860049"
     WithOffset:0
     andCount:20
     onSuccess:^(NSArray *comments) {
         
         [self.commentsArray addObjectsFromArray:comments];
         
         NSMutableArray *indexPaths = [NSMutableArray array];
         
         for (int i = (int)([self.commentsArray count]+2) - (int)[comments count];
              i < ([self.commentsArray count]+2); i++) {
             [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         
         [self.tableView
          reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
                               withRowAnimation:UITableViewRowAnimationNone];

         [self.tableView insertRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationRight];
         [self.tableView endUpdates];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

#pragma mark - PDMessageViewControllerDelegate

- (void) addMyCommentToTableView {
    
    [[PDServerManager sharedManager] setGetOneComment:YES];
    
    self.needToAddComment = NO;
    
    [[PDServerManager sharedManager]
     getCommentsOfPost:self.postID
     OfOwner:@"-58860049"
     WithOffset:[self.commentsArray count]
     andCount:1
     onSuccess:^(NSArray *comments) {
         
         [self.commentsArray addObjectsFromArray:comments];
         
         NSMutableArray *indexPaths = [NSMutableArray array];
         
         [indexPaths addObject:[NSIndexPath indexPathForRow:[self.commentsArray count]+1 inSection:0]];
         
         [self.tableView beginUpdates];
         
         [self.tableView
          reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]
          withRowAnimation:UITableViewRowAnimationNone];
         
         [self.tableView insertRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationRight];
         [self.tableView endUpdates];
         
     } onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

#pragma mark - PDPostViewCellDelegate 

- (void) refreshFirstCell {
    
    NSLog(@"self.postID %@", self.postID);
    self.isLiked = YES;
    
    [self.tableView beginUpdates];
    
    [self.tableView
     reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
     withRowAnimation:UITableViewRowAnimationNone];
    
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.commentsArray count] + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        static NSString *identifier = @"PostCell";
        
        PDPostViewCell *postCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        postCell.delegate = self;
        
        PDPost *post = self.post;
        
        postCell.textLbl.text = post.text;
        
        NSDate *dateOfPost = [NSDate dateWithTimeIntervalSince1970:[post.date doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm dd/MMM/yyyy"];
        
        postCell.dateLbl.text = [dateFormatter stringFromDate:dateOfPost];
        
        postCell.nameLbl.text = post.name;
        postCell.userID = post.fromID;
        postCell.postID = post.postID;
        
        NSInteger likesCount;
        
        if (self.isLiked) {
            likesCount = post.likesCount + 1;
        } else {
            likesCount = post.likesCount;
        }
        
        postCell.likesLbl.text = [NSString stringWithFormat:@"%lu", likesCount];
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[post imageURL]];
        
        postCell.photoView.image = nil;
        
        __weak PDPostViewCell *weakCell = postCell;
        
        [postCell.photoView setImageWithURLRequest:imageRequest
                                     placeholderImage:nil
                                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                  
                                                  weakCell.photoView.image = image;
                                                  [weakCell layoutSubviews];
                                                  
                                              }            failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                  
                                                  NSLog(@"%@", [error localizedDescription]);
                                              }];
        return postCell;
        
    } else if (indexPath.row == 1) {
        
        static NSString *identifier = @"CountCell";
        
        PDCommentsCountViewCell *countCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        NSString *text = nil;
        
        if ([self.commentsArray count] == 1) {
            text = [NSString stringWithFormat:@"%lu Comment", [self.commentsArray count]];
        } else {
            text = [NSString stringWithFormat:@"%lu Comments", [self.commentsArray count]];
        }
        
        countCell.commentsCountLbl.text = text;
        
        return countCell;
    
    } else if (indexPath.row == [self.commentsArray count] + 2) {
        
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"Tap To Add Your Comment";
        cell.imageView.image = nil;
        
        return cell;
    
    } else {
        
        static NSString *identifier = @"CommentCell";
        
        PDPostViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        PDComment *comment = [self.commentsArray objectAtIndex:indexPath.row - 2];
        
        commentCell.textLbl.text = comment.text;
        commentCell.dateLbl.text = comment.date;
        
        commentCell.nameLbl.text = comment.name;
        commentCell.userID = comment.fromID;
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[comment imageURL]];
        
        commentCell.photoView.image = nil;
        
        __weak PDPostViewCell *weakCell = commentCell;
        
        [commentCell.photoView setImageWithURLRequest:imageRequest
                                     placeholderImage:nil
                                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                  
                                                  weakCell.photoView.image = image;
                                                  [weakCell layoutSubviews];
                                                  
                                              }            failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                  
                                                  NSLog(@"%@", [error localizedDescription]);
                                              }];
        return commentCell;
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        
        return 44.f;
        
    } else if (indexPath.row == 0) {
        
        PDPost* post = self.post;
        
        return [PDPostViewCell heightForText:post.text] + 70;
    
    } else if (indexPath.row == [self.commentsArray count] + 2) {
        
        return 44.f;
    
    } else {
        
        PDComment *comment = [self.commentsArray objectAtIndex:indexPath.row - 2];
        
        return [PDPostViewCell heightForText:comment.text] + 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.commentsArray count] + 2) {
        
        self.needToAddComment = YES;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *commentNav =
                    [storyboard instantiateViewControllerWithIdentifier:@"MessageNavigationController"];
        
        PDMessageViewController *commentVC = [commentNav.viewControllers firstObject];
        commentVC.postID = self.postID;
        
//        UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
        
        [self presentViewController:commentNav
                             animated:YES
                           completion:nil];
    }
}

#pragma mark - My Methods

- (void) addCommentToTableView {
    
    
}









@end
