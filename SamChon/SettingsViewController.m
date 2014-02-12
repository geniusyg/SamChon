//
//  SettingsViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SettingsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface SettingsViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SettingsViewController {
	AppDelegate *_ad;
}

- (IBAction)loginLogout:(id)sender {
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
			[_ad sessionStateChanged:session state:state error:error];
			
			[FBRequestConnection startWithGraphPath:@"/me"
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
										  NSLog(@"%@", [result objectForKey:@"id"]);
									  }
								  }];
		}];
    }
	self.tabBarController.selectedIndex = 0;
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
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		[self.loginButton setTitle:@"로그아웃" forState:UIControlStateNormal];
		
    } else {
        [self.loginButton setTitle:@"로그인" forState:UIControlStateNormal];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

	_ad = [[UIApplication sharedApplication] delegate];
	
	[_ad openSessionWithAllowLoginUI:NO];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































