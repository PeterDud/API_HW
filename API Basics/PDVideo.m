//
//  PDVideo.m
//  API Basics
//
//  Created by Lavrin on 5/31/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDVideo.h"

@implementation PDVideo

- (instancetype) initWithResponse:(NSDictionary *) response
{
    self = [super init];
    if (self) {
        
        self.name = [response objectForKey:@"title"];
        self.imageURL = [NSURL URLWithString:[response objectForKey:@"photo_320"]];
        self.videoPlayURL = [NSURL URLWithString:[response objectForKey:@"player"]];
    }
    return self;
}

@end
