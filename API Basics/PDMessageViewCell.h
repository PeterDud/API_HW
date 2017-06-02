//
//  PDMessageViewCell.h
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDMessageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@property (strong, nonatomic) NSString *userID;

+ (CGFloat) heightForText:(NSString*) text;

- (IBAction)respondClicked:(UIButton *)sender;

@end
