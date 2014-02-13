//
//  AppDelegate.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

@implementation AppDelegate {
	NSArray *fList;
	NSDictionary *fList2;
}

NSString *const FBSessionStateChangedNotification = @"264586667033355:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[FBLoginView class];
	
	[FBSettings setDefaultAppID:@"264586667033355"];

	[self openSessionWithAllowLoginUI:NO];
	
    return YES;
}

- (void)networkLogin {
					AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
					NSDictionary *parameters = @{@"id":self.uid, @"profilePic":self.purl, @"name":self.uname, @"friId":fList2};
					[manager POST:@"http://samchon.ygw3429.cloulu.com/login/enrollFriList2" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
						NSLog(@"JSON: %@", responseObject);
					} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
						NSLog(@"Error: %@", error);
					}];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
		
    return [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,FBSessionState state, NSError *error) {
        [self sessionStateChanged:session state:state error:error];
    }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if(!error) {
                NSLog(@"Facebook User session found");
            
			
//			if([[NSUserDefaults standardUserDefaults] integerForKey:@"isFirstLogin"]) {
//				// 첫 로그인이 아님
//			} else {
//				//첫 로그인임
//				[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"isFirstLogin"];
//			}
//			
			[FBRequestConnection startWithGraphPath:@"/me?fields=id,name,friends,picture"
										 parameters:nil
										 HTTPMethod:@"GET"
								  completionHandler:^(
													  FBRequestConnection *connection,
													  NSDictionary *result,
													  NSError *error
													  ) {
									  if(error) {
										  NSLog(@"Graph error : %@", error);
									  } else {
										  self.uid = [NSString stringWithFormat:@"%@", [result objectForKey:@"id"]];
										  
										  self.uname = [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
										  
										  NSDictionary* friends = [result objectForKey:@"friends"];
										  
										  NSArray *arr = [friends objectForKey:@"data"];
										  
										  self.fids = [[NSMutableDictionary alloc] init];
										  
//										  NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
										  
//										  for(NSDictionary<FBGraphUser>* user in arr) {
//											  NSMutableDictionary* dicFriend = [[NSMutableDictionary alloc] init];
//											  
//											  [dicFriend setObject: [user objectForKey:@"id"] forKey: @"id"];
//											  [dicFriend setObject: user.name forKey: @"name"];
//											  
//											  [self.fids setObject:dicFriend forKey:@"friId"];
//										  }
//										  fList = [NSArray arrayWithArray:arr];
//										  fList2 = [NSDictionary dictionaryWithDictionary:friends];
//										  NSLog(@"%@", fList);
//										  NSLog(@"%@, %@", self.uid, self.uname);
//										  NSLog(@"%@", fids);
										  
										  
										  NSDictionary *pic = [result objectForKey:@"picture"];
										  NSDictionary *pic2 = [pic objectForKey:@"data"];
										  self.purl = [pic2 objectForKey:@"url"];
										  
										  [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"uid"];
										  [[NSUserDefaults standardUserDefaults] setObject:self.uname forKey:@"uname"];
										  [[NSUserDefaults standardUserDefaults] setObject:self.purl forKey:@"upic"];
										  
									  }
								  }];

//				[FBRequestConnection startWithGraphPath:@"/me/picture?type=large"
//											 parameters:nil
//											 HTTPMethod:@"GET"
//									  completionHandler:^(
//														  FBRequestConnection *connection,
//														  NSDictionary *result,
//														  NSError *error
//														  ) {
//										  if(error) {
//											  NSLog(@"Graph error : %@", error);
//										  } else {
//											 NSDictionary *pic = [result objectForKey:@"picture"];
//											 NSDictionary *pic2 = [pic objectForKey:@"data"];
//											 self.purl = [pic2 objectForKey:@"url"];
//										  }
//									  }];
				
//				[self performSelector:@selector(networkLogin) withObject:nil afterDelay:2.0];
			}
            break;
        case FBSessionStateClosed:
            NSLog(@"Facebook SessionStateClosed");
            break;
        case FBSessionStateClosedLoginFailed:
            NSLog(@"SessionStateColsedLoginFailed");
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    
    if(error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)moveTap {

}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end


























