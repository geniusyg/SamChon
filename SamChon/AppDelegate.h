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

extern NSString *const FBSessionStateChangedNotification;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error;
- (void) networkLogin;

@property (strong, nonatomic) UIWindow *window;

@end



















