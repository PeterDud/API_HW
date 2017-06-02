//
//  PDPost.h
//  API Basics
//
//  Created by Lavrin on 5/14/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPost : NSObject

@property (strong, nonatomic) NSArray  *attachments;
@property (strong, nonatomic) NSNumber *date;
@property (strong, nonatomic) NSString *fromID;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSURL    *imageURL;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger likesCount;
@property (assign, nonatomic) NSInteger commentsCount;

@property (strong, nonatomic) NSString *postID;

@property (strong, nonatomic) NSString *repostText;
@property (strong, nonatomic) NSString *repostOwnerID;
@property (strong, nonatomic) NSString *repostDate;

- (instancetype)initWithResponse:(NSDictionary *) response;

@end
