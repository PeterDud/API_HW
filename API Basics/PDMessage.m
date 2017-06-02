//
//  PDMessage.m
//  API Basics
//
//  Created by Lavrin on 5/26/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDMessage.h"

@implementation PDMessage

- (instancetype)initWithResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        
        self.fromID = [response objectForKey:@"user_id"];
        self.text = [response objectForKey:@"body"];
        
        NSNumber *date = [response objectForKey:@"date"];
        NSDate *dateOfMessage = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm dd/MMM/yyyy"];
        
        self.date = [dateFormatter stringFromDate:dateOfMessage];

        
    }
    return self;
}

@end
