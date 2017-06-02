//
//  PDPhotoAlbum.m
//  API Basics
//
//  Created by Lavrin on 5/28/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPhotoAlbum.h"

@implementation PDPhotoAlbum

- (instancetype) initWithResponse:(NSDictionary *) response
{
    self = [super init];
    if (self) {
        
        self.name = [response objectForKey:@"title"];
        self.imageURL = [NSURL URLWithString:[response objectForKey:@"thumb_src"]];
    }
    return self;
}

@end
