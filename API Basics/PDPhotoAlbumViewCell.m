//
//  PDPhotoAlbumViewCell.m
//  API Basics
//
//  Created by Lavrin on 5/28/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPhotoAlbumViewCell.h"
#import "AFNetworking.h"
#import "UIImagePickerController+HiddenAPIs.h"
#import "PDServerManager.h"

@interface PDPhotoAlbumViewCell () <UINavigationControllerDelegate, UIImagePickerControllerHiddenAPIDelegate>


@end

@implementation PDPhotoAlbumViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addPhotosClicked:(UIButton *)sender {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [imagePickerController setAllowsMultipleSelection:YES];

    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:imagePickerController animated:YES completion:nil];

}

#pragma mark - UIImagePickerControllerHiddenAPIDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfoArray:(NSArray *)infoArray
{
    NSMutableArray *imageLocations = [NSMutableArray array];
    
    for (NSDictionary *infoDictionary in infoArray) {
        
        NSLog(@"%@", infoDictionary);
        
        UIImage *image = [infoDictionary objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageLocations addObject:image];
    }
    
    NSLog(@"%@", imageLocations);
    if ([imageLocations count] > 0) {
        
        [[PDServerManager sharedManager] uploadImages:infoArray];
    }
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancelled");
}





@end
