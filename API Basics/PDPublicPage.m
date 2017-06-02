//
//  PDPublicPage.m
//  API Basics
//
//  Created by Lavrin on 5/13/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPublicPage.h"

@implementation PDPublicPage

- (instancetype)initWithResponse:(NSDictionary *) response
{
    self = [super init];
    if (self) {
        
        self.name = [response objectForKey:@"name"];
        
        NSString *url = [response objectForKey:@"photo"];
        if (url) {
            self.imageURL = [NSURL URLWithString:url];
        }
        
    }
    return self;
}

@end
