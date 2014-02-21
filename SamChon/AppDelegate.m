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
	NSArray *replyArr;
	CLLocationManager *_lm;
}

NSString *const FBSessionStateChangedNotification = @"264586667033355:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	
//	[NSThread sleepForTimeInterval:1.5f];
	
	self.categories = @[@"한식", @"일식", @"중식", @"양식", @"치킨", @"패스트푸드", @"세계요리", @"기타"];
	self.selectedCategory = @"9";
	
	[FBLoginView class];
	
	[FBSettings setDefaultAppID:@"264586667033355"];

	[self openSessionWithAllowLoginUI:NO];
	
	_lm = [[CLLocationManager alloc] init];
	
	_lm.delegate = self;
	_lm.desiredAccuracy = kCLLocationAccuracyBest;
	_lm.distanceFilter = 1000.0f;
	[_lm startUpdatingLocation];
	
//	[NSThread sleepForTimeInterval:1.5f];
	
    return YES;
}

- (void)getStoreInfo:(NSString *)storeID {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"storeId":storeID, @"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/shopInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.storeInfo_storeId = [responseObject objectForKey:@"storeId"];
			self.storeInfo_storeName = [responseObject objectForKey:@"storeName"];
			self.storeInfo_storeAddr = [responseObject objectForKey:@"storeAddr"];
			self.storeInfo_lat = [responseObject objectForKey:@"lat"];
			self.storeInfo_lng = [responseObject objectForKey:@"lng"];
			self.storeInfo_isLike = [responseObject objectForKey:@"isLike"];
			self.storeInfo_storeFri1 = [responseObject objectForKey:@"storeFri1"];
			self.storeInfo_storeFri2 = [responseObject objectForKey:@"storeFri2"];
			self.storeInfo_storeFri3 = [responseObject objectForKey:@"storeFri3"];
			self.storeInfo_storePic = [responseObject objectForKey:@"storePic"];
			self.storeInfo_reply = [responseObject objectForKey:@"reply"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"shopInfo" object:nil];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getFriendStores:(NSString *)friId {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"friId":friId, @"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/fri/friBoardList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.friPic = [responseObject objectForKey:@"picture"];
			self.friStores = [responseObject objectForKey:@"myStoreList"];
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"fristores" object:nil];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = [locations lastObject];
    self.currentLat = [NSString stringWithFormat:@"%lf", location.coordinate.latitude];
    self.currentLng = [NSString stringWithFormat:@"%lf", location.coordinate.longitude];
	
	[_lm stopUpdatingLocation];
}

- (void)getStoreFris:(NSString *)lat lng:(NSString *)lng {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"lat":lat, @"lng":lng};
	[manager POST:@"http://samchon.ygw3429.cloulu.com//finder/recommendList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		NSLog(@"%@", responseObject);
		self.storeFri1 = [NSArray arrayWithArray:[responseObject objectForKey:@"storeFri1"]];
		self.storeFri2 = [NSArray arrayWithArray:[responseObject objectForKey:@"storeFri2"]];
		self.storeFri3 = [NSArray arrayWithArray:[responseObject objectForKey:@"storeFri3"]];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)writeShopReplys:(NSString *)comment {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"storeId":self.storeInfo_storeId, @"comment":comment};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/writeReply" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			NSLog(@"success Write Reply");
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)writeReplys:(NSString *)postingNum comment:(NSString *)comment {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"postingNum":postingNum, @"comment":comment};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/write/writeReplyBoard" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		NSLog(@"success Write Reply");
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getMyBoardList {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/myPage/myBoardList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.myBoardList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"myStoreList"]];
			
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getMyPick {
	AFHTTPRequestOperationManager *manager3 = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
	[manager3 POST:@"http://samchon.ygw3429.cloulu.com/myPage/myPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.myPicks = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"myPickList"]];
		}
		//		NSLog(@"%@", [responseObject objectForKey:@"myPickList"]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)login {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/myPage/myBoardList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		self.myBoardList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"myStoreList"]];
			
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	AFHTTPRequestOperationManager *manager2 = [AFHTTPRequestOperationManager manager];
	[manager2 POST:@"http://samchon.ygw3429.cloulu.com/fri/myFriends" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.storeFri1 = [NSArray arrayWithArray:[responseObject objectForKey:@"fri1"]];
//			NSLog(@"%@",[responseObject objectForKey:@"fri1"]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	AFHTTPRequestOperationManager *manager3 = [AFHTTPRequestOperationManager manager];
	[manager3 POST:@"http://samchon.ygw3429.cloulu.com/myPage/myPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		self.myPicks = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"myPickList"]];
		}
//		NSLog(@"%@", [responseObject objectForKey:@"myPickList"]);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	AFHTTPRequestOperationManager *manager4 = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters4 = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"lat":self.currentLat, @"lng":self.currentLng};
	[manager4 POST:@"http://samchon.ygw3429.cloulu.com/finder/recommendList2" parameters:parameters4 success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.recommendFri1 = [responseObject objectForKey:@"fri1"];
			self.recommendFri2 = [responseObject objectForKey:@"fri2"];
			self.recommendFri3 = [responseObject objectForKey:@"fri3"];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
}

- (void)getRecommendList {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"lat":self.currentLat, @"lng":self.currentLng};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/finder/recommendList2" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		self.recommendFri1 = [responseObject objectForKey:@"fri1"];
		self.recommendFri2 = [responseObject objectForKey:@"fri2"];
		self.recommendFri3 = [responseObject objectForKey:@"fri3"];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getShopReplys {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]  , @"storeId":self.storeInfo_storeId};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/shopInfoReply" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			self.storeInfo_reply =  [NSMutableArray arrayWithArray:[responseObject objectForKey:@"reply"]];
			//		NSLog(@"direct - %@", [responseObject objectForKey:@"reply"]);
			
			[[NSNotificationCenter defaultCenter] postNotificationName:@"store_reply" object:nil];
			
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)getReplys:(NSString *)uid storeID:(NSString *)storeID postingNum:(NSString *)postingNum{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":uid, @"storeId":storeID, @"postingNum":postingNum};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/myPage/myBoard" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		self.reply =  [NSMutableArray arrayWithArray:[responseObject objectForKey:@"reply"]];
//		NSLog(@"direct - %@", [responseObject objectForKey:@"reply"]);
			
		[[NSNotificationCenter defaultCenter] postNotificationName:@"reply" object:nil];
			
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (void)networkLogin {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"profilePic":self.purl, @"name":self.uname, @"friId":fList2};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/login/enrollFriList2" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
		NSLog(@"JSON: %@", responseObject);
		}
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
					
			[FBRequestConnection startWithGraphPath:@"/me?fields=id,name,friends,picture.type(large)"
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
										  
//										  NSDictionary* friends = [result objectForKey:@"friends"];
										  
//										  NSArray *arr = [friends objectForKey:@"data"];
										  
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

//				[self performSelector:@selector(networkLogin) withObject:nil afterDelay:2.0];
				[self performSelector:@selector(login) withObject:nil afterDelay:1.5];
//					[self getMyBoardList];
					
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































