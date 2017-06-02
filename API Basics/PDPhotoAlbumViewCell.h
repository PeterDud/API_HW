//
//  PDPhotoAlbumViewCell.h
//  API Basics
//
//  Created by Lavrin on 5/28/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDPhotoAlbumViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;

- (IBAction)addPhotosClicked:(UIButton *)sender;

@end
