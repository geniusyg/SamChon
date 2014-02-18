//
//  AppDelegate.h
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property NSString *uid;
@property NSString *uname;
@property NSString *purl;
@property NSMutableDictionary *fids;
@property NSDictionary *writeSearch;

@property NSArray *reply;
@property NSMutableArray *myBoardList;
@property NSMutableArray *myFriends;

extern NSString *const FBSessionStateChangedNotification;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void) networkLogin;
- (void)getMyBoardList;
- (NSArray *)getReplys:(NSString *)storeID postingNum:(NSString *)postingNum;
- (void)writeReplys:(NSString *)storeID comment:(NSString *)comment;

@property (strong, nonatomic) UIWindow *window;

@end



















