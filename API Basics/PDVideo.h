//
//  PDVideo.h
//  API Basics
//
//  Created by Lavrin on 5/31/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDVideo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *videoPlayURL;

- (instancetype) initWithResponse:(NSDictionary *) response;

@end
