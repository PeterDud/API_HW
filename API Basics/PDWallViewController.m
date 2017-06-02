//
//  PDWallViewController.m
//  API Basics
//
//  Created by Lavrin on 5/18/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDWallViewController.h"
#import "PDServerManager.h"
#import "PDPublicPage.h"
#import "UIImageView+AFNetworking.h"
#import "PDProfileViewController.h"
#import "PDPostingViewController.h"
#import "PDMyMessagesTVC.h"
#import "PDCommentTVC.h"
#import "PDPhotoAlbumsTVC.h"
#import "PDVideosTVC.h"

#import "PDPostViewCell.h"

#import "PDUser.h"
#import "PDPost.h"

@interface PDWallViewController ()

@property (strong, nonatomic) NSMutableArray *postsArray;
@property (assign, nonatomic) BOOL firstTimeAppear;
@property (assign, nonatomic) BOOL needsRefresh;
@end

@implementation PDWallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.postsArray = [NSMutableArray array];
    self.userID = @"-58860049";
    
    [self getPostsFromServer];
    
    self.firstTimeAppear = YES;
    
    self.title = @"iOS Dev Course";
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.needsRefresh) {
        self.needsRefresh = NO;
        [self refreshWall];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - API

-(void) getPostsFromServer {
    
    [[PDServerManager sharedManager]
      getPostsOfUser:self.userID
      WithOffset:[self.postsArray count]
      andCount:10
      onSuccess:^(NSArray *posts) {
    
          [self.postsArray addObjectsFromArray: posts];
          
          NSMutableArray *indexPaths = [NSMutableArray array];
          
          for (int i = (int)[self.postsArray count] - (int)[posts count];
               i < [self.postsArray count]; i++) {
              [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
          }
          
          [self.tableView beginUpdates];
          [self.tableView insertRowsAtIndexPaths:indexPaths
                                withRowAnimation:UITableViewRowAnimationRight];
          [self.tableView endUpdates];

    
}     onFailure:^(NSError *error, NSInteger statusCode) {
    
        NSLog(@"%@", [error localizedDescription]);
}];
    
}

- (void) postOnWall:(id) sender {
    
    [[PDServerManager sharedManager]
     postText:@"Это тест из урока номер 47!"
     onGroupWall:@"58860049"
     onSuccess:^(id result) {
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         
     }];
}


- (void) refreshWall {
    
    [[PDServerManager sharedManager]
     getPostsOfUser:self.userID
     WithOffset:0
     andCount:MAX(10, [self.postsArray count])
     onSuccess:^(NSArray *posts) {
         
         [self.postsArray removeAllObjects];
         
         [self.postsArray addObjectsFromArray:posts];
         
         [self.tableView reloadData];
         
     }     onFailure:^(NSError *error, NSInteger statusCode) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 2;
    } else {
        return [self.postsArray count]+1;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Media";
    } else {
        return @"Posts";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"Photo Albums";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"photo.png"];
        
        return cell;
   
    } else if (indexPath.row == 1 && indexPath.section == 0) {
     
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        }
        
        cell.textLabel.text = @"Videos";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"video.png"];
        
        return cell;
        
    } else if (indexPath.row == [self.postsArray count] && indexPath.section == 1) {
        
        static NSString *identifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        }

        cell.textLabel.text = @"More";
        cell.imageView.image = nil;
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"PostCell";
        
        PDPostViewCell *postCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        PDPost *post = [self.postsArray objectAtIndex:indexPath.row];
        
        postCell.textLbl.text = post.text;
        postCell.likesLbl.text = [NSString stringWithFormat:@"%lu", post.likesCount];
        postCell.commentsLbl.text = [NSString stringWithFormat:@"%lu", post.commentsCount];
        
        NSDate *dateOfPost = [NSDate dateWithTimeIntervalSince1970:[post.date doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm dd/MMM/yyyy"];
        
        postCell.dateLbl.text = [dateFormatter stringFromDate:dateOfPost];
        postCell.nameLbl.text = post.name;
        postCell.userID = post.fromID;
        
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
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row == [self.postsArray count] && indexPath.section == 1) ||
        (indexPath.row <= 1 && indexPath.section == 0)) {
        
        return 44.f;
        
    } else {
        
        PDPost* post = [self.postsArray objectAtIndex:indexPath.row];
        
        return [PDPostViewCell heightForText:post.text] + 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
 
        PDPhotoAlbumsTVC *photoAlbumsTVC =
                        [storyboard instantiateViewControllerWithIdentifier:@"PDPhotoAlbumsTVC"];

        [self.navigationController pushViewController:photoAlbumsTVC animated:YES];
    
    } else if (indexPath.section == 0 && indexPath.row == 1) {
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PDVideosTVC *videosTVC =
        [storyboard instantiateViewControllerWithIdentifier:@"PDVideosTVC"];
        
        [self.navigationController pushViewController:videosTVC animated:YES];
        
    } else if (indexPath.row == [self.postsArray count] && indexPath.section == 1) {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self getPostsFromServer];

    } else if (indexPath.section == 1) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        PDCommentTVC *commentsTVC = [storyboard instantiateViewControllerWithIdentifier:@"PDCommentTVC"];
        
        PDPost* post = [self.postsArray objectAtIndex:indexPath.row];
        
        commentsTVC.post = post;
        commentsTVC.postID = post.postID;
        
        [self.navigationController pushViewController:commentsTVC animated:YES];
    }
}

#pragma mark - Action Methods

- (IBAction)addClicked:(id)sender {
    
    self.needsRefresh = YES;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *nvc = [storyboard instantiateViewControllerWithIdentifier:@"PostingNavigationController"];
    
    [self presentViewController:nvc
                       animated:YES
                     completion:nil];
}

- (IBAction)myMessagesClicked:(UIBarButtonItem *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    PDMyMessagesTVC *messagesTVC =
                [storyboard instantiateViewControllerWithIdentifier:@"PDMyMessagesTVC"];
    
    [self.navigationController pushViewController:messagesTVC animated:YES];
}

#pragma mark - Other Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
