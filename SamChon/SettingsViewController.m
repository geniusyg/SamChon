//
//  SettingsViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginBtn;

@end

@implementation SettingsViewController
- (IBAction)printState:(id)sender {
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"fbID"];
	NSLog(@"logged out");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
	[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"fbID"];
	NSLog(@"logged in");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
//	NSLog(@"%@", user);
//	[FBRequestConnection startWithGraphPath:@"/me"
//								 parameters:nil
//								 HTTPMethod:@"GET"
//						  completionHandler:^(
//											  FBRequestConnection *connection,
//											  id result,
//											  NSError *error
//											  ) {
//							  if(error) {
//								  NSLog(@"Graph error : %@", error);
//							  } else {
//								  NSDictionary *nsd = (NSDictionary *)result;
//								  NSLog(@"%@", [nsd objectForKey:@"id"]);
////								  NSLog(@"%@", result);
//							  }
//						  }];
}

- (IBAction)puchOnOff:(id)sender {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self.loginBtn setReadPermissions:@[@"basic_info"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































