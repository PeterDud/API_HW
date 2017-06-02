//
//  PDServerManager.h
//  API Basics
//
//  Created by Lavrin on 5/10/17.
//  Copyright © 2017 Lavrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PDUser, UINavigationController;

@interface PDServerManager : NSObject

@property (assign, nonatomic) BOOL getOneComment;

+ (PDServerManager *) sharedManager;

- (void) getFriendWithOffset:(NSInteger) offset
                    andCount:(NSInteger) count
                   onSuccess:(void(^)(NSArray *friends)) success
                   onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) goToPageOfUser:(NSString *) ID
              onSuccess:(void(^)(PDUser *user)) success
              onFailure:(void(^)(NSError *error)) failure;

- (void) getFollowersOfUser:(NSString *) userID
                 WithOffset:(NSInteger) offset
                   andCount:(NSInteger) count
                  onSuccess:(void(^)(NSArray *users)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) getSubscriptionsOfUser:(NSString *) userID
                     WithOffset:(NSInteger) offset
                       andCount:(NSInteger) count
                      onSuccess:(void(^)(NSArray *subsriptions)) success
                      onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) getPostsOfUser:(NSString *) userID
             WithOffset:(NSInteger) offset
               andCount:(NSInteger) count
              onSuccess:(void(^)(NSArray *subsriptions)) success
              onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) authorizeUser:(void(^)(PDUser* user)) completion;

- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) sendMessage:(NSString*) text
              toUser:(NSString*) userID
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getMessagesWithOffset:(NSInteger) offset
                      andCount:(NSInteger) count
                     onSuccess:(void(^)(NSArray *posts)) success
                     onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) getCommentsOfPost:(NSString *) postID
                   OfOwner:(NSString *) ownerID
                WithOffset:(NSInteger) offset
                  andCount:(NSInteger) count
                 onSuccess:(void(^)(NSArray *comments)) success
                 onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) commentText:(NSString*) text
              toPost:(NSString*) postID
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) addLikeToPost:(NSString*) postID
             onSuccess:(void(^)(id result)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getPhotoAlbumsOnSuccess:(void(^)(NSArray *photoAlbums)) success
                       onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

- (void) uploadImages:(NSArray *) imageInfo;

- (void) getVideosFromServerWithCount:(NSInteger) count
                           withOffset:(NSInteger) offset
                             OnSucess: (void(^)(NSArray *videos)) success
                            onFailure: (void(^)(NSError *error)) failure;

@end
