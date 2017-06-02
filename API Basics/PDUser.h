//
//  PDUser.h
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (assign, nonatomic) NSString *userID;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *bigImageURL;
@property (strong, nonatomic) NSString *dateOfBirth;
@property (strong, nonatomic) NSString *countryCityHometown;
//@property (strong, nonatomic) NSString *education;
@property (strong, nonatomic) NSString *contacts;
//@property (strong, nonatomic) NSString *occupation;
@property (strong, nonatomic) NSString *career;


- (id) initWithServerResponse:(NSDictionary *) response;

@end
