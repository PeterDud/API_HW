//
//  PDPostViewCell.h
//  API Basics
//
//  Created by Lavrin on 5/18/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PDPostViewCellDelegate;

@interface PDPostViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UILabel *likesLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentsLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (weak, nonatomic) id <PDPostViewCellDelegate> delegate;

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *postID;

+ (CGFloat) heightForText:(NSString*) text;

- (IBAction)photoClicked:(UIButton *)sender;
- (IBAction)likeClicked:(UIButton *)sender;

@end


@protocol PDPostViewCellDelegate

- (void) refreshFirstCell;

@end










