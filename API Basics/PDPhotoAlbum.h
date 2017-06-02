//
//  PDPhotoAlbum.h
//  API Basics
//
//  Created by Lavrin on 5/28/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPhotoAlbum : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageURL;

- (instancetype) initWithResponse:(NSDictionary *) response;

@end
