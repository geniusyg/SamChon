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

@interface SettingsViewController () 
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SettingsViewController {
	AppDelegate *_ad;
}

- (IBAction)loginLogout:(id)sender {
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
		[self performSelector:@selector(goMain) withObject:nil afterDelay:1.0];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
			[_ad sessionStateChanged:session state:state error:error];
			[self performSelector:@selector(goMain) withObject:nil afterDelay:2.0];
		}];
    }
}

- (void)goMain {
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

	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[_ad openSessionWithAllowLoginUI:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































