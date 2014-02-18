//
//  AppDelegate.h
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property NSString *uid;
@property NSString *uname;
@property NSString *purl;
@property NSMutableDictionary *fids;
@property NSDictionary *writeSearch;
@property NSString *selectedCategory;

@property NSArray *categories;

@property NSMutableArray *reply;
@property NSMutableArray *myBoardList;

@property NSArray *storeFri1;
@property NSArray *storeFri2;
@property NSArray *storeFri3;

@property NSString *currentLat;
@property NSString *currentLng;

extern NSString *const FBSessionStateChangedNotification;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void) networkLogin;
- (void)getMyBoardList;
- (NSArray *)getReplys:(NSString *)storeID postingNum:(NSString *)postingNum;
- (void)writeReplys:(NSString *)storeID comment:(NSString *)comment;
- (void)getStoreFris:(NSString *)lat lng:(NSString *)lng;

@property (strong, nonatomic) UIWindow *window;

@end



















