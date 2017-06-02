//
//  PDLoginViewController.h
//  API Basics
//
//  Created by Lavrin on 5/21/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDAccessToken;

typedef void(^PDLoginCompletionBlock)(PDAccessToken *token);

@interface PDLoginViewController : UIViewController

- (id) initWithCompletionBlock:(PDLoginCompletionBlock) completionBlock;

@end
