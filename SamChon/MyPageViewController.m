//
//  MyPageViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyPageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface MyPageViewController () 
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *MyShop;
@property (weak, nonatomic) IBOutlet UIView *FirstFriends;
@property (weak, nonatomic) IBOutlet UIView *IWant;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation MyPageViewController {
	AppDelegate *_ad;
}
- (IBAction)login:(id)sender {
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

- (IBAction)segChanged:(id)sender {
	UISegmentedControl *sc = (UISegmentedControl *)sender;
	switch (sc.selectedSegmentIndex) {
		case 0:
			self.MyShop.hidden = NO;
			self.FirstFriends.hidden = YES;
			self.IWant.hidden = YES;
			break;
		case 1:
			self.MyShop.hidden = YES;
			self.FirstFriends.hidden = NO;
			self.IWant.hidden = YES;
			break;
		case 2:
			self.MyShop.hidden = YES;
			self.FirstFriends.hidden = YES;
			self.IWant.hidden = NO;
			break;
	}
	
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
		self.loginView.hidden = YES;
		
		UIImage *imgWeb;
		NSURL *url;
		
		
		url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"upic"]];
		
		if( url != nil )
			imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url ]];
		
		if( imgWeb != nil )
			self.profileImage.image = imgWeb;
		
    } else {
        self.loginView.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_ad = [[UIApplication sharedApplication] delegate];
	
	self.MyShop.hidden = NO;
	self.FirstFriends.hidden = YES;
	self.IWant.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






































