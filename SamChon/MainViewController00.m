//
//  MainViewController00.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 23..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MainViewController00.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface MainViewController00 ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *friCount;

@end

@implementation MainViewController00 {
	AppDelegate *_ad;
}

- (void)showMyInfo {
	self.postCount.text = _ad.userPostCnt;
	self.friCount.text = _ad.userFriCnt;
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
		UIImage *imgWeb;
		NSURL *url;
		
		url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"upic"]];
		
		if( url != nil )
			imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url ]];
		
		if( imgWeb != nil )
			self.profileImg.image = imgWeb;
		
    } else {
        self.profileImg.image = nil;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[_ad getMyInfo];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyInfo) name:@"myInfo" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


























