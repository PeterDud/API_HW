//
//  PDMessageViewCell.m
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDMessageViewCell.h"
#import "PDMessageViewController.h"

@implementation PDMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightForText:(NSString*) text {
    
    CGFloat offset = 5.0;
    
    UIFont* font = [UIFont systemFontOfSize:14.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(320 - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    
    
    return CGRectGetHeight(rect) + 2 * offset;
}

- (IBAction)respondClicked:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *messageNav =
    [storyboard instantiateViewControllerWithIdentifier:@"MessageNavigationController"];
    
    PDMessageViewController *messageVC = [messageNav.viewControllers firstObject];
    messageVC.userID = self.userID;
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:messageNav
                         animated:YES
                       completion:nil];
}

@end
