//
//  RecommendViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecommendViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface RecommendViewController () <UIScrollViewAccessibilityDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closePopupBtn;

@property (weak, nonatomic) IBOutlet UIButton *closeModalBtn;
@property (weak, nonatomic) IBOutlet UIImageView *recommendImage;
@property (weak, nonatomic) IBOutlet UILabel *recommendAddr;
@property (weak, nonatomic) IBOutlet UITextView *recommendDetail;
@property (weak, nonatomic) IBOutlet UILabel *recommendTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *recommendView;
@property (weak, nonatomic) IBOutlet UIImageView *myPic;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView0;
@property (weak, nonatomic) IBOutlet UIView *blackView;

@end

@implementation RecommendViewController {
	AppDelegate *_ad;
	BOOL _checked;
	NSInteger _index;
	NSInteger _index2;
	NSDictionary *_recommendStore;
	NSDictionary *_currentStore;
}
- (IBAction)refresh:(id)sender {
	[self showRecommend];
}

- (IBAction)moveMap:(id)sender {
	_ad.storeMapInfo = [NSMutableDictionary dictionaryWithDictionary:_currentStore];

}

- (void)recommendRequest {
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:_index];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":_ad.uid, @"friId":[tmp objectForKey:@"friId"], @"friendNum":[NSString stringWithFormat:@"%ld", [_ad.storeFri1 count]]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/main/recommendWithFri" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			_recommendStore = (NSDictionary *)responseObject;
			_index2 = 0;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"recommendFri" object:nil];
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (IBAction)closePopup:(id)sender {
	self.recommendView.hidden = YES;
	self.closeModalBtn.hidden = NO;
	self.bottomView0.alpha = 1.0;
	self.topView.alpha = 1.0;
	self.blackView.hidden = YES;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake && _checked) {
		[self recommendRequest];
		
		self.topView.alpha = 0.5;
		self.bottomView0.alpha = 0.5;
		self.closeModalBtn.hidden = YES;
		self.blackView.hidden = NO;
		
		_checked = NO;
    }
}

- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	_checked = NO;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showRecommend) name:@"recommendFri" object:nil];
}

- (void)showRecommend {
	NSString *myc = [_recommendStore objectForKey:@"myCategory"];
	NSString *fric = [_recommendStore objectForKey:@"friCategory"];
	NSArray *storeList = [_recommendStore objectForKey:@"storeList"];
	_currentStore = [storeList objectAtIndex:_index2++];
	
	self.recommendDetail.text = [NSString stringWithFormat:@"%@ & %@에게\n만족할 추천 맛집은 여기!",myc,fric];
	self.recommendDetail.textAlignment = NSTextAlignmentCenter;
	self.recommendTitle.text = [_currentStore objectForKey:@"storeName"];
	self.recommendAddr.text = [_currentStore objectForKey:@"storeAddr"];
	NSString *path = [_currentStore objectForKey:@"foodPic"];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	self.recommendImage.image = [UIImage imageWithData:data];

	self.recommendView.hidden = NO;
}

- (void) imageTapped:(UITapGestureRecognizer *)gr {	
	UIImageView *theTappedImageView = (UIImageView *)gr.view;
	_index = theTappedImageView.tag - 100;
	
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:_index];
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"friPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	
	self.imageView.image = img;
	self.imageView.layer.cornerRadius = 30.0f;
	self.imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	self.imageView.layer.shouldRasterize = YES;
	self.imageView.clipsToBounds = YES;
	
	_checked = YES;
}

- (void)initView {
	NSString *path = _ad.purl;
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	self.myPic.image = img;
	
	self.myPic.layer.cornerRadius = 30.0f;
	self.myPic.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	self.myPic.layer.shouldRasterize = YES;
	self.myPic.clipsToBounds = YES;
	
	CGFloat scrollWidth = 10.f;
	for (int i = 0; i<[_ad.storeFri1 count]; i++) {
		NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:i];
		
		UIImageView *theView = [[UIImageView alloc] initWithFrame:
								CGRectMake(scrollWidth, 0, 61, 61)];
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollWidth, 70, 61, 20)];
		nameLabel.text = [tmp objectForKey:@"friName"];
		nameLabel.textAlignment = NSTextAlignmentCenter;
		nameLabel.font = [UIFont fontWithName:UIFontTextStyleBody size:12];
		
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
		
		singleTap.numberOfTapsRequired = 1;
		theView.userInteractionEnabled = YES;
		theView.tag = i + 100;
		[theView addGestureRecognizer:singleTap];
		
		path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"friPic"]];
		url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		data = [NSData dataWithContentsOfURL:url];
		img = [UIImage imageWithData:data];
		
		theView.image = img;
		theView.layer.cornerRadius = 30.0f;
		theView.layer.rasterizationScale = [UIScreen mainScreen].scale;
		
		theView.layer.shouldRasterize = YES;
		theView.clipsToBounds = YES;
		[self.scrollView addSubview:theView];
		[self.scrollView addSubview:nameLabel];
		scrollWidth += 100;
	}
	self.scrollView.contentSize = CGSizeMake(scrollWidth, 80);
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initView) name:@"getFriendsList" object:nil];
	
	[_ad getMyFriends];
	
	[self becomeFirstResponder];
	
	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























