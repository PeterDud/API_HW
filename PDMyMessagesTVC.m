//
//  PDMyMessagesTVC.m
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDMyMessagesTVC.h"
#import "PDMessageViewCell.h"
#import "PDServerManager.h"

#import "UIImageView+AFNetworking.h"

#import "PDMessage.h"

@interface PDMyMessagesTVC ()

@property (strong, nonatomic) NSMutableArray *messagesArray;

@end

@implementation PDMyMessagesTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messagesArray = [NSMutableArray array];
    
    [self getMessagesFromServer];
    
    self.title = @"My Messages";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void) getMessagesFromServer {
    
    [[PDServerManager sharedManager]
     getMessagesWithOffset:[self.messagesArray count]
     andCount:10
     onSuccess:^(NSArray *messages) {
         
         [self.messagesArray addObjectsFromArray:messages];
         
         NSMutableArray *indexPaths = [NSMutableArray array];
         
         for (int i = (int)[self.messagesArray count] - (int)[messages count];
              i < [self.messagesArray count]; i++) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.messagesArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.messagesArray count]) {
        
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
        
        static NSString *identifier = @"MessageCell";
        
        PDMessageViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        PDMessage *message = [self.messagesArray objectAtIndex:indexPath.row];
        
        messageCell.textLbl.text = message.text;
        
        messageCell.dateLbl.text = message.date;
        messageCell.nameLbl.text = message.name;
        messageCell.userID = message.fromID;
        
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[message imageURL]];
        
        messageCell.photoView.image = nil;
        
        __weak PDMessageViewCell *weakCell = messageCell;
        
        [messageCell.photoView setImageWithURLRequest:imageRequest
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                               
                                               weakCell.photoView.image = image;
                                               [weakCell layoutSubviews];
                                               
                                           }            failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                               
                                               NSLog(@"%@", [error localizedDescription]);
                                           }];
        
        return messageCell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.messagesArray count]) {
        
        return 44.f;
        
    } else {
        
        PDMessage* post = [self.messagesArray objectAtIndex:indexPath.row];
        
        return [PDMessageViewCell heightForText:post.text] + 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.messagesArray count]) {
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self getMessagesFromServer];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
