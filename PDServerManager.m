//
//  PDServerManager.m
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import "PDServerManager.h"
#import "AFNetworking.h"
#import "PDLoginViewController.h"

#import "PDUser.h"
#import "PDPublicPage.h"
#import "PDPost.h"
#import "PDMessage.h"
#import "PDComment.h"
#import "PDPhotoAlbum.h"
#import "PDVideo.h"

#import "PDAccessToken.h"

@interface PDServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) PDAccessToken* accessToken;

@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation PDServerManager

+ (PDServerManager *) sharedManager {
    
    static PDServerManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PDServerManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURL * baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}


- (void) getFriendWithOffset:(NSInteger) offset
                    andCount:(NSInteger) count
                    onSuccess:(void(^)(NSArray *friends)) success
                    onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"384145582", @"user_id",
                            @"name", @"order",
                            @(count), @"count",
                            @(offset), @"offset",
                            @"photo_50", @"fields",
                            @"nom", @"name_case",
                            nil];
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSLog(@"friends.get %@", responseObject);
                         
                         NSArray *dictsArray = [responseObject objectForKey:@"response"];
                         
                         NSMutableArray *users = [NSMutableArray array];
                         
                         for (NSDictionary *response in dictsArray) {
                             
                             PDUser *user = [[PDUser alloc] initWithServerResponse:response];
                             [users addObject:user];
                         }
                         
                         if (success) {
                             success(users);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSLog(@"%@", [error localizedDescription]);
                                                  
                         if (failure) {
                             failure(error, 0);
                         }
                     }];
}

- (void) goToPageOfUser:(NSString *) userID
          onSuccess:(void(^)(PDUser *user)) success
          onFailure:(void(^)(NSError *error)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"user_id",
                            @"bdate,country,city,home_town,contacts,career,photo_200", @"fields",
                            @"nom", @"name_case",
                            nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSLog(@"%@", responseObject);
                         
                         NSArray *dictArray = [responseObject objectForKey:@"response"];
                         NSDictionary *response = [dictArray objectAtIndex:0];
                         
                         PDUser *user = [[PDUser alloc] initWithServerResponse:response];
                         
                         if (success) {
                             success(user);
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(error);
                         }
                     }];
}

- (void) getFollowersOfUser:(NSString *) userID
                 WithOffset:(NSInteger) offset
                    andCount:(NSInteger) count
                   onSuccess:(void(^)(NSArray *users)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID,      @"user_id",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_50", @"fields",
                            @"nom",      @"name_case",
                            nil];
    [self.sessionManager
     GET:@"users.getFollowers"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"users.getFollowers %@", responseObject);
         
         NSDictionary *contentDicts = [responseObject objectForKey:@"response"];

         NSArray *dictsArray = [contentDicts objectForKey:@"items"];
         
         NSMutableArray *followersArray = [NSMutableArray array];
         
         for (NSDictionary *response in dictsArray) {
             
             PDUser *follower = [[PDUser alloc] initWithServerResponse:response];
             [followersArray addObject:follower];
         }
         
         if (success) {
             success(followersArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (void) getSubscriptionsOfUser:(NSString *) userID
                 WithOffset:(NSInteger) offset
                   andCount:(NSInteger) count
                  onSuccess:(void(^)(NSArray *subsriptions)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"user_id",
                            @1, @"extended",
                            @(count), @"count",
                            @(offset), @"offset",
                            nil];
    [self.sessionManager
     GET:@"users.getSubscriptions"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@", responseObject);
         
//         NSDictionary *contentsDicts = [responseObject objectForKey:@"response"];
         
         NSArray *dictsArray = [responseObject objectForKey:@"response"];
         
         NSMutableArray *subscriptionsArray = [NSMutableArray array];
         
         for (NSDictionary *response in dictsArray) {
             
             PDPublicPage *subscription = [[PDPublicPage alloc] initWithResponse: response];
             [subscriptionsArray addObject:subscription];
         }
         
         if (success) {
             success(subscriptionsArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (void) getPostsOfUser:(NSString *) userID
             WithOffset:(NSInteger) offset
               andCount:(NSInteger) count
              onSuccess:(void(^)(NSArray *posts)) success
              onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"owner_id",
                            @(offset), @"offset",
                            @(count), @"count",
                            @1, @"extended",
                            nil];
    
    NSMutableArray *postsArray = [NSMutableArray array];

    [self.sessionManager
     GET:@"wall.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSDictionary *dictsOfDicts = [responseObject objectForKey:@"response"];
         
         NSArray *postsResponsesArray = [dictsOfDicts objectForKey:@"wall"];
         
         NSLog(@"wall: %@", postsResponsesArray);
         
         for (id response in postsResponsesArray) {
             
             if ([response isKindOfClass:[NSNumber class]]) {
                 continue;
             }
             PDPost *post = [[PDPost alloc] initWithResponse: response];
             [postsArray addObject:post];
         }
         
         if (success) {
             self.postsArray = postsArray;
             [self addNameAndPhotoToItems:postsArray
                                withCount:10
                           withCompletion:^{
                               
                              success(postsArray);
                           }];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);

         if (failure) {
             failure(error, 0);
         }
     }];
    
}

- (void) addNameAndPhotoToItems:(NSArray *) items
                      withCount:(int) count
                 withCompletion:(void (^)(void)) completion {
    
    static int i;
    
    i = 0;
    
    for (id item in items) {
        
        NSLog(@"%@", [item fromID]);
        
        __block NSString *url = nil;
        
        if ([[item fromID] doubleValue] < 0) {
            
            int groupID = -[[item fromID] intValue];
            
            NSString *stringID = [NSString stringWithFormat:@"%i", groupID];
            
            NSDictionary *paramsGroup = [NSDictionary dictionaryWithObjectsAndKeys:
                                         stringID, @"group_ids",
                                         @"description", @"fields",
                                         self.accessToken.token, @"access_token",
                                         @"version", @"5.64",
                                         nil];

            
            [self.sessionManager GET:@"groups.getById"
                          parameters:paramsGroup
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                 i++;
                                 NSLog(@"%@", responseObject);
                                 NSArray *dictArray = [responseObject objectForKey:@"response"];

                                 NSDictionary *response = [dictArray objectAtIndex:0];

                                 url = [response objectForKey:@"photo"];
                                 NSString *name = [response objectForKey:@"name"];
                                 
                                 [item setImageURL:[NSURL URLWithString:url]];
                                 [item setName:name];
                                 
                                 if (i == count) {
                                     i = 0;
                                     if (completion) {
                                         completion();
                                     }
                                 }
                             } failure:nil];
        } else {
        
        NSDictionary *paramsPhotoURL = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [item fromID], @"user_id",
                                        @"photo_50", @"fields",
                                        nil];

        [self.sessionManager GET:@"users.get"
                      parameters:paramsPhotoURL
                        progress:nil
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             i++;
                             NSLog(@"%@", responseObject);
                             
                             NSArray *dictArray = [responseObject objectForKey:@"response"];
                             NSDictionary *response = [dictArray objectAtIndex:0];
                             
                             url = [response objectForKey:@"photo_50"];
                             NSString *firstName = [response objectForKey:@"first_name"];
                             NSString *lastName = [response objectForKey:@"last_name"];

                             [item setImageURL:[NSURL URLWithString:url]];
                             [item setName:[NSString stringWithFormat:@"%@ %@", firstName, lastName]];
                             
                             if (i == count) {
                                 i = 0;
                                 if (completion) {
                                     completion();
                                 }
                             }
                         } failure:nil
         ];
    }
}
    
}

- (void) authorizeUser:(void(^)(PDUser* user)) completion {
    
    PDLoginViewController* vc =
    [[PDLoginViewController alloc] initWithCompletionBlock:^(PDAccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
                onSuccess:^(PDUser *user) {
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(PDUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.sessionManager
     GET:@"users.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"JSON: %@", responseObject);
         
         NSArray* dictsArray = [responseObject objectForKey:@"response"];
         
         if ([dictsArray count] > 0) {
             PDUser* user = [[PDUser alloc] initWithServerResponse:[dictsArray firstObject]];
             if (success) {
                 success(user);
             }
         } else {
             if (failure) {
                 failure(nil, 0);
             }
         }

     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"Error: %@", error);
         
         if (failure) {
             failure(error, 0);
         }
     }];
}

- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSLog(@"access token: %@", self.accessToken.token);
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,       @"owner_id",
     text,          @"message",
     self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager
     POST:@"wall.post"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             failure(error, 0);
         }
     }];    
}

- (void) sendMessage:(NSString*) text
              toUser:(NSString*) userID
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userID, @"user_id",
                            text, @"message",
                            self.accessToken.token, @"access_token",
                            nil];
    
    [self.sessionManager
     POST:@"messages.send"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             failure(error, 0);
         }
     }];
}

- (void) getMessagesWithOffset:(NSInteger) offset
                      andCount:(NSInteger) count
                     onSuccess:(void(^)(NSArray *messages)) success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(offset), @"offset",
                            @(count), @"count",
                            @(0), @"preview_length",
                            self.accessToken.token, @"access_token",
                            @"5.64", @"v",
                            nil];
    
    [self.sessionManager
     GET:@"messages.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSDictionary *response = [responseObject objectForKey:@"response"];
         
         NSArray *arrayOfDicts = [response objectForKey:@"items"];
         
         NSLog(@"arrayOfDicts: %@", arrayOfDicts);
         
         NSMutableArray *messagesArray = [NSMutableArray array];
         
         for (NSDictionary *response in arrayOfDicts) {
             
             PDMessage *message = [[PDMessage alloc] initWithResponse:response];
             
             [messagesArray addObject:message];
         }
         
         if (success) {
             
             [self addNameAndPhotoToItems:messagesArray
                                withCount:10
                           withCompletion:^{
                               
                               success(messagesArray);
                           }];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (void) getCommentsOfPost:(NSString *) postID
                   OfOwner:(NSString *) ownerID
                WithOffset:(NSInteger) offset
                  andCount:(NSInteger) count
                 onSuccess:(void(^)(NSArray *comments)) success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            ownerID, @"owner_id",
                            postID, @"post_id",
                            @1, @"need_likes",
                            @(offset), @"offset",
                            @(count), @"count",
                            @"5.64", @"v",
                            nil];
    
    [self.sessionManager
     GET:@"wall.getComments"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@", responseObject);
         
         NSDictionary *dictOfDicts = [responseObject objectForKey:@"response"];
         int count;
         
         if (self.getOneComment) {
             count = 1;
         } else {
             count = [[dictOfDicts objectForKey:@"count"] intValue];
         }
         
         NSArray *responsesArray = [dictOfDicts objectForKey:@"items"];
         
         NSMutableArray *commentsArray = [NSMutableArray array];
         
         for (NSDictionary *response in responsesArray) {
             
             PDComment *comment = [[PDComment alloc] initWithResponse:response];
             [commentsArray addObject:comment];
         }
         
         if (success) {
             self.getOneComment = NO;
             [self addNameAndPhotoToItems:commentsArray
                                withCount:count
                           withCompletion:^{
                               
                               success(commentsArray);
                           }];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (void) commentText:(NSString*) text
              toPost:(NSString*) postID
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"-58860049", @"owner_id",
                            postID, @"post_id",
                            text, @"message",
                            self.accessToken.token, @"access_token",
                            nil];
    
    [self.sessionManager
    POST:@"wall.createComment"
    parameters:params
    progress:nil
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

- (void) addLikeToPost:(NSString*) postID
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"post", @"type",
                            postID, @"item_id",
                            @"-58860049", @"owner_id",
                            self.accessToken.token, @"access_token",
                            nil];
    [self.sessionManager
     POST:@"likes.add"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@", responseObject);
         
         if (success) {
             success(responseObject);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         
     }];
}

- (void) getPhotoAlbumsOnSuccess:(void(^)(NSArray *photoAlbums)) success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"-58860049", @"owner_id",
                            @1, @"need_covers",
                            self.accessToken.token, @"access_token",
                            @"5.64", @"v",
                            nil];
    
    [self.sessionManager
     GET:@"photos.getAlbums"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@", responseObject);
         
         NSDictionary *dictOfDicts = [responseObject objectForKey:@"response"];
         NSArray *responsesArray = [dictOfDicts objectForKey:@"items"];
         
         NSMutableArray *photoAlbumsArray = [NSMutableArray array];
         
         for (NSDictionary *response in responsesArray) {
             
             PDPhotoAlbum *photoAlbum = [[PDPhotoAlbum alloc] initWithResponse:response];
             [photoAlbumsArray addObject:photoAlbum];
         }
         
         if (success) {
             success(photoAlbumsArray);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"%@", [error localizedDescription]);
     }];
}

- (void) uploadImages:(NSArray *) imageInfo {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"232640461", @"album_id",
                            @"58860049", @"group_id",
                            self.accessToken.token, @"access_token",
                            nil];
    
    [self.sessionManager
     GET:@"photos.getUploadServer"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSDictionary *response = [responseObject objectForKey:@"response"];
         NSString *uploadURL = [response objectForKey:@"upload_url"];
         NSLog(@"%@", responseObject);
         
         [self uploadImagesOnServer:uploadURL
                     withImageInfo:imageInfo];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         
     }];
}

- (void) uploadImagesOnServer:(NSString *) uploadURL
               withImageInfo:(NSArray *) imagesInfo {
    
    NSLog(@"%@", uploadURL);
    NSLog(@"%@", imagesInfo);

    for (NSDictionary *imageDict in imagesInfo) {
    
    UIImage *image = imageDict[UIImagePickerControllerOriginalImage];
        
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    NSLog(@"%@", jpgPath);

    NSString *boundary = [self generateBoundaryString];
    
    // configure the request
    
    NSMutableURLRequest *request =
                    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uploadURL]];
    [request setHTTPMethod:@"POST"];
    
    // set content type
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:nil paths:@[jpgPath] fieldName:@"file1"];

    NSURLSession *session = [NSURLSession sharedSession];  // use sharedSession or create your own
    
    NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error = %@", error);
            return;
        }
    
//        NSString *result = [[NSDictionary alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSError* error2;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error2];

        NSLog(@"result = %@", json);
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                json[@"aid"], @"album_id",
                                json[@"gid"], @"group_id",
                                json[@"server"], @"server",
                                json[@"photos_list"], @"photos_list",
                                json[@"hash"], @"hash",
                                self.accessToken.token, @"access_token",
                                nil];
        [self.sessionManager
         POST:@"photos.save"
         parameters:params
         progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSLog(@"%@", responseObject);
             UIAlertController* alert =
             [UIAlertController alertControllerWithTitle:@"Alert"
             message:@"Upload is complete"
             preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {}];
             
             [alert addAction:defaultAction];
             
             UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
             
             [mainVC presentViewController:alert animated:YES completion:nil];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         }];
    }];
    [task resume];
    }
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

- (void) getVideosFromServerWithCount:(NSInteger) count
                           withOffset:(NSInteger) offset
                             OnSucess: (void(^)(NSArray *videos)) success
                            onFailure: (void(^)(NSError *error)) failure {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"-58860049", @"owner_id",
                            @(count), @"count",
                            @(offset), @"offset",
                            self.accessToken.token, @"access_token",
                            @"5.64", @"v",
                            nil];
    
    [self.sessionManager
     GET:@"video.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"%@", responseObject);
         
         NSDictionary *dictOfDicts = [responseObject objectForKey:@"response"];
         NSArray *responsesArray = [dictOfDicts objectForKey:@"items"];
         
         NSMutableArray *videos = [NSMutableArray array];
         
         for (NSDictionary *response in responsesArray) {
             
             PDVideo *video = [[PDVideo alloc] initWithResponse:response];
             [videos addObject:video];
         }
         
         if (success) {
             success(videos);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         
     }];
    
}







@end
