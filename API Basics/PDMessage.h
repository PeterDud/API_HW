//
//  PDMessage.h
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMessage : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageURL;

@property (strong, nonatomic) NSString *fromID;

- (instancetype) initWithResponse: (NSDictionary *) response;

@end
