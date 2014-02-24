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
@property NSString *selectedAddr;

@property NSArray *categories;

@property NSMutableArray *reply;
@property NSMutableArray *myBoardList;
@property NSMutableArray *myPicks;

@property NSArray *storeFri1;
@property NSArray *storeFri2;
@property NSArray *storeFri3;

@property NSString *friPic;
@property NSArray *friStores;

@property NSString *currentLat;
@property NSString *currentLng;

@property NSArray *recommendFri1;
@property NSArray *recommendFri2;
@property NSArray *recommendFri3;

@property NSDictionary *storeInfo;
@property NSMutableArray *storeReply;
@property NSString *storeId;

//@property NSString *storeInfo_storeId;
//@property NSString *storeInfo_storeName;
//@property NSString *storeInfo_storeAddr;
//@property NSString *storeInfo_lat;
//@property NSString *storeInfo_lng;
//@property NSString *storeInfo_isLike;
//@property NSArray *storeInfo_storeFri1;
//@property NSArray *storeInfo_storeFri2;
//@property NSArray *storeInfo_storeFri3;
//@property NSArray *storeInfo_storePic;
//@property NSArray *storeInfo_reply;

@property NSMutableDictionary *storeMapInfo;

@property NSString *userFriCnt;
@property NSString *userPostCnt;
@property NSArray *categoryCount;

@property BOOL isClear;


extern NSString *const FBSessionStateChangedNotification;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void)networkLogin;
- (void)getMyBoardList;
- (void)getMyPick;
- (void)getMyFriends;
- (void)getMyInfo;
- (void)getReplys:(NSString *)uid storeID:(NSString *)storeID postingNum:(NSString *)postingNum;
- (void)writeReplys:(NSString *)storeID comment:(NSString *)comment;
//- (void)getStoreFris:(NSString *)lat lng:(NSString *)lng;
- (void)getFriendStores:(NSString *)friId;
- (void)getRecommendList;
- (void)getShopReplys:(NSString *)storeId;
- (void)getStoreInfo:(NSString *)storeID;
- (void)writeShopReplys:(NSString *)comment;

@property (strong, nonatomic) UIWindow *window;

@end



















