//
//  ViewController.m
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDViewController.h"
#import "PDServerManager.h"
#import "PDUser.h"
#import "PDPublicPage.h"
#import "UIImageView+AFNetworking.h"
#import "PDProfileViewController.h"

@interface PDViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *usersArray;
@property (assign, nonatomic) BOOL firstTimeAppear;

@end

@implementation PDViewController

static NSInteger usersInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.usersArray = [NSMutableArray array];

    if (self.userID && !self.isSubscriptionsList) {
        [self getFollowersFromServer];
    } else if (self.userID && self.isSubscriptionsList) {
        [self getSubscriptionsFromServer];
    } else {
        [self getFriendsFromServer];
    }
    
    
    self.firstTimeAppear = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

#pragma mark - API

-(void) getFriendsFromServer {
    
    [[PDServerManager sharedManager] getFriendWithOffset:[self.usersArray count]
        andCount:usersInRequest
        onSuccess:^(NSArray *friends) {
    
            [self addUsersToTableView:friends];
            
}
        onFailure:^(NSError *error, NSInteger statusCode) {
            
            NSLog(@"%@", [error localizedDescription]);
}];

}

-(void) getFollowersFromServer {
    
    [[PDServerManager sharedManager] getFollowersOfUser:self.userID
        WithOffset:[self.usersArray count]
        andCount:usersInRequest
        onSuccess:^(NSArray *users) {

            [self addUsersToTableView:users];
    
}       onFailure:^(NSError *error, NSInteger statusCode) {
    
            NSLog(@"%@", [error localizedDescription]);
}];
    
}

-(void) getSubscriptionsFromServer {
    
    [[PDServerManager sharedManager] getSubscriptionsOfUser:self.userID
        WithOffset:[self.usersArray count]
        andCount:usersInRequest
        onSuccess:^(NSArray *subsriptions) {
    
            [self addUsersToTableView:subsriptions];
            
}       onFailure:^(NSError *error, NSInteger statusCode) {
    
            NSLog(@"%@", [error localizedDescription]);
}];
}

#pragma mark - Custom Methods

- (void) addUsersToTableView:(NSArray *) users {
    
    [self.usersArray addObjectsFromArray: users];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    for (int i = (int)[self.usersArray count] - (int)[users count];
         i < [self.usersArray count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.usersArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    if (indexPath.row == [self.usersArray count]) {
     
        cell.textLabel.text = @"More";
        cell.imageView.image = nil;
        
    } else {
        
        id item = [self.usersArray objectAtIndex:indexPath.row];
        
        if (self.isSubscriptionsList) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [item name]];
        } else {
            cell.textLabel.text =[NSString stringWithFormat:@"%@ %@", [item firstName], [item lastName]];
        }

        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[item imageURL]];
        
        cell.imageView.image = nil;
        
        __weak UITableViewCell *weakCell = cell;
        
        [cell.imageView setImageWithURLRequest:imageRequest
            placeholderImage:nil
            success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                           
                weakCell.imageView.image = image;
                [weakCell layoutSubviews];
                
}            failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
    
                NSLog(@"%@", [error localizedDescription]);
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.usersArray count]) {
        
        if (self.userID && !self.isSubscriptionsList) {
            [self getFollowersFromServer];
        } else if (self.userID && self.isSubscriptionsList){
            [self getSubscriptionsFromServer];
        } else {
            [self getFriendsFromServer];
        }
   
    } else {
        
        if (self.isSubscriptionsList == NO) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            PDProfileViewController *profileVC = [storyboard
                                                  instantiateViewControllerWithIdentifier:@"PDProfileViewController"];
            [profileVC loadView];
            
            PDUser *friend = [self.usersArray objectAtIndex:indexPath.row];
            
            NSLog(@"friend %@", friend.userID);
            //        __weak PDProfileViewController *weakProfileVC = profileVC;
            
            [[PDServerManager sharedManager]
             goToPageOfUser:friend.userID
             onSuccess:^(PDUser *user) {
                 
                 NSLog(@"user %@", user.userID);
                 
                 NSURLRequest *photoRequest = [NSURLRequest requestWithURL:user.bigImageURL];
                 
                 [profileVC.profilePhoto setImageWithURLRequest:photoRequest
                                               placeholderImage:nil
                                                        success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                                            
                                                            profileVC.profilePhoto.image = image;
                                                        }         failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                            
                                                            NSLog(@"%@", [error localizedDescription]);
                                                        }];
                 
                 profileVC.name.text = [NSString stringWithFormat:@"%@ %@",
                                        user.firstName, user.lastName];
                 profileVC.dateOfBirth.text = user.dateOfBirth;
                 profileVC.countryCityHometown.text = user.countryCityHometown;
                 profileVC.contacts.text = user.contacts;
                 profileVC.follower = user;
                 
                 [self.navigationController pushViewController:profileVC animated:YES];
                 
             }     onFailure:^(NSError *error) {
                 
                 NSLog(@"%@", [error localizedDescription]);
             }];
        }
    }
}

#pragma mark - Other Methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
