//
//  PDVideosTVC.m
//  API Basics
//
//  Created by Lavrin on 5/31/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDVideosTVC.h"
#import "PDServerManager.h"
#import "PDVideoViewCell.h"
#import "PDVideo.h"
#import "PDVideoViewController.h"

#import "UIImageView+AFNetworking.h"

@interface PDVideosTVC ()

@property (strong, nonatomic) NSMutableArray *videosArray;

@end

@implementation PDVideosTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videosArray = [NSMutableArray array];
    
    [self getVideosFromServer];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - API

- (void) getVideosFromServer {
    
    [[PDServerManager sharedManager]
     getVideosFromServerWithCount:10
     withOffset:[self.videosArray count]
     OnSucess:^(NSArray *videos) {
         
         [self.videosArray addObjectsFromArray: videos];
         
         NSMutableArray *indexPaths = [NSMutableArray array];
         
         for (int i = (int)[self.videosArray count] - (int)[videos count];
              i < [self.videosArray count]; i++) {
             [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:indexPaths
                               withRowAnimation:UITableViewRowAnimationRight];
         [self.tableView endUpdates];

     } onFailure:^(NSError *error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.videosArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"VideoCell";
    
    PDVideoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    PDVideo *video = [self.videosArray objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = video.name;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:video.imageURL];
    
    __weak PDVideoViewCell* weakCell = cell;
    
    cell.thumbView.image = nil;
    
    [cell.thumbView
     setImageWithURLRequest:request
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         weakCell.thumbView.image = image;
         [weakCell layoutSubviews];
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         
     }];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[PDServerManager sharedManager]
     getVideosFromServerWithCount:1
     withOffset:indexPath.row
     OnSucess:^(NSArray *videos) {
         
         PDVideo *video = [videos firstObject];
         
         PDVideoViewController *videoVC = [[PDVideoViewController alloc] init];
         videoVC.video = video;
         UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:videoVC];
         
         [self presentViewController:nc animated:YES completion:nil];
         
     } onFailure:^(NSError *error) {
         
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
