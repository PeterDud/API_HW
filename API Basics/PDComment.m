//
//  PDComment.m
//  API Basics
//
//  Created by Lavrin on 5/27/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDComment.h"

@implementation PDComment

- (instancetype) initWithResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        
        self.fromID = [response objectForKey:@"from_id"];
        
        self.text = [response objectForKey:@"text"];
        
        NSNumber *date = [response objectForKey:@"date"];
        NSDate *dateOfMessage = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm dd/MMM/yyyy"];
        
        self.date = [dateFormatter stringFromDate:dateOfMessage];

    }
    return self;
}

@end
