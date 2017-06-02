//
//  PDPhotoAlbumsTVC.m
//  API Basics
//
//  Created by Lavrin on 5/28/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPhotoAlbumsTVC.h"
#import "PDServerManager.h"
#import "PDPhotoAlbumViewCell.h"
#import "UIImageView+AFNetworking.h"

#import "PDPhotoAlbum.h"

@interface PDPhotoAlbumsTVC ()

@property (strong, nonatomic) NSMutableArray *photoAlbumsArray;

@end

@implementation PDPhotoAlbumsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoAlbumsArray = [NSMutableArray array];
    
    [self getPhotoAlbumsFromServer];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - API

- (void) getPhotoAlbumsFromServer {
    
    [[PDServerManager sharedManager]
    getPhotoAlbumsOnSuccess:^(NSArray *photoAlbums) {
        
        [self.photoAlbumsArray addObjectsFromArray: photoAlbums];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (int i = (int)[self.photoAlbumsArray count] - (int)[photoAlbums count];
             i < [self.photoAlbumsArray count]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        NSLog(@"%@", [error localizedDescription]);
    }];
}


#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.photoAlbumsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"PhotoAlbumCell";
    
    PDPhotoAlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    PDPhotoAlbum *photoAlbum = [self.photoAlbumsArray objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = photoAlbum.name;
    
    NSURLRequest* request = [NSURLRequest requestWithURL:photoAlbum.imageURL];
    
    __weak PDPhotoAlbumViewCell* weakCell = cell;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
