//
//  PDUser.m
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDUser.h"

@implementation PDUser

- (instancetype) initWithServerResponse:(NSDictionary *) response
{
    self = [super init];
    if (self) {
        
        self.firstName = [response objectForKey:@"first_name"];
        self.lastName = [response objectForKey:@"last_name"];
        
        self.userID = [response objectForKey:@"user_id"];
        if ([response objectForKey:@"user_id"] == nil) {
            self.userID = [response objectForKey:@"uid"];
        }
        self.dateOfBirth = [response objectForKey:@"bdate"];
        NSString *country = [response objectForKey:@"country"];
        NSString *city = [response objectForKey:@"city"];
        NSString *hometown = [response objectForKey:@"home_town"];
        self.countryCityHometown = [NSString stringWithFormat:@"%@, %@, %@.", country, city, hometown];
//        self.education = [response objectForKey:@"education"];
        self.contacts = [response objectForKey:@"contacts"];
//        self.occupation = [response objectForKey:@"occupation"];
        self.career = [response objectForKey:@"career"];
                
        NSString *urlString = [response objectForKeyedSubscript:@"photo_50"];
        NSString *bigURLString = [response objectForKeyedSubscript:@"photo_200"];

        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        if (bigURLString) {
            self.bigImageURL = [NSURL URLWithString:bigURLString];
        }
    }
    return self;
}

@end
