//
//  PDPost.m
//  API Basics
//
//  Created by Lavrin on 5/14/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDPost.h"

@implementation PDPost

- (instancetype)initWithResponse:(NSDictionary *) response 
{
    self = [super init];
    if (self) {
        
        self.attachments = [response objectForKey:@"attachments"];
        self.date = [response objectForKey:@"date"];
        self.fromID = [response objectForKey:@"from_id"];
        self.text = [response objectForKey:@"text"];

        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        NSDictionary *comments = [response objectForKey:@"comments"];
        self.commentsCount = [[comments objectForKey:@"count"]  integerValue];
        NSDictionary *likes = [response objectForKey:@"likes"];
        self.likesCount = [[likes objectForKey:@"count"]  integerValue];
        
        self.postID = [response objectForKey:@"id"];
        
        NSString *url = [response objectForKey:@"photo_50"];
        
        if (url) {
            self.imageURL = [NSURL URLWithString:url];
        }
        
        self.repostText = [response objectForKey:@"copy_text"];
        self.repostDate = [response objectForKey:@"copy_post_date"];
        self.repostOwnerID = [response objectForKey:@"copy_owner_id"];
    }
    return self;
}

@end
