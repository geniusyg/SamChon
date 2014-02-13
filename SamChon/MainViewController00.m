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

@end

@implementation MainViewController00

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
		
		// 위에서 URL이 잘못되어 있으면 이미지를 가져오지 못하므로 UIImage는 nil이 된다.
		
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


























