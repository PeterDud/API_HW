//
//  PDProfileViewController.h
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUser.h"

@interface PDProfileViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *dateOfBirth;
@property (weak, nonatomic) IBOutlet UILabel *countryCityHometown;
@property (weak, nonatomic) IBOutlet UILabel *education;
@property (weak, nonatomic) IBOutlet UILabel *contacts;
@property (weak, nonatomic) IBOutlet UILabel *connections;

@property (strong, nonatomic) PDUser *follower;


@end
