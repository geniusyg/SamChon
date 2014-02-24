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
#import "AFNetworking.h"

@interface MainViewController00 ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;
@property (weak, nonatomic) IBOutlet UIImageView *gImg;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet UILabel *friCount;

@property (weak, nonatomic) IBOutlet UILabel *detailView;

@end

@implementation MainViewController00 {
	AppDelegate *_ad;
	NSDictionary *_se;
	NSDictionary *_il;
	NSDictionary *_jung;
	NSDictionary *_yang;
	NSDictionary *_chi;
	NSDictionary *_fast;
	NSDictionary *_han;
	NSInteger _max;
	NSInteger _maxNum;
	NSDictionary *_maxDic;
	NSString *_maxString;
	NSArray *_categoryNames;
}

- (void)showMyInfo {
	self.postCount.text = _ad.userPostCnt;
	self.friCount.text = _ad.userFriCnt;
	
	if(![@"0" isEqualToString:self.postCount.text]) {
		int gage = [self.postCount.text intValue] % 5;
		NSString *gname = [NSString stringWithFormat:@"g_%d.png",++gage];
	
		self.gImg.image = [UIImage imageNamed:gname];
	} else {
		self.gImg.image = [UIImage imageNamed:@"g_0.png"];
	}
	
	if([@"0" isEqualToString:_ad.userPostCnt]) {
		self.detailView.text = @"반가워요. 단골식당을 추천해주세요!";
	} else if([@"1" isEqualToString:_ad.userPostCnt]) {
		self.detailView.text = @"반가워요. 단골식당을 추천해주세요!";
	} else if([@"2" isEqualToString:_ad.userPostCnt]) {
		self.detailView.text = @"당신의 음식 취향을 파악중이에요!";
	} else if([@"3" isEqualToString:_ad.userPostCnt]) {
		self.detailView.text = @"입맛 독특하신데요? 하나 더 알려주세요!";
	} else {
	
	_se = [_ad.categoryCount objectAtIndex:0];
	_il = [_ad.categoryCount objectAtIndex:1];
	_jung = [_ad.categoryCount objectAtIndex:2];
	_yang = [_ad.categoryCount objectAtIndex:3];
	_chi = [_ad.categoryCount objectAtIndex:4];
	_fast = [_ad.categoryCount objectAtIndex:5];
	_han = [_ad.categoryCount objectAtIndex:6];
	
		for(int i=0; i<7; i++) {
			NSDictionary *tmp1 = [_ad.categoryCount objectAtIndex:i];
			NSInteger tmp1num = (NSInteger)[tmp1 objectForKey:@"value"];

			if(_max < tmp1num) {
				_max = tmp1num;
				_maxNum = i;
			}
		}
		
		self.detailView.text = [_categoryNames objectAtIndex:_maxNum];
		
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
		UIImage *imgWeb;
		NSURL *url;
		
		url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"upic"]];
		
		if( url != nil )
			imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
		
		if( imgWeb != nil )
			self.profileImg.image = imgWeb;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMyInfo) name:@"myInfo" object:nil];
		
		[_ad getMyInfo];
		
    } else {
        self.profileImg.image = nil;
    }
	
	_max = 0;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
//	_categoryNames = @[@"세계요리", @"일식", @"중식", @"양식", @"치킨", @"패스트푸드", @"한식"];
	_categoryNames = @[@"각종 향신료를 향한 독특미각!", @"당신이 그 전설의 초밥와?", @"언제나 중화요리에 굶주린 당신!", @"까다로운 당신은 쉐프가 요리한다!", @"1인 1닭을 외치는 칰힌좀비!", @"버거와 감튀에 중독된 초딩입맛!", @"된장남녀! 그대는 1% 토종입맛!"];
	
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


























