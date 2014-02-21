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
@property (weak, nonatomic) IBOutlet UIImageView *bottomView2;

@end

@implementation RecommendViewController {
	AppDelegate *_ad;
	BOOL _checked;
	NSInteger _index;
}
- (IBAction)refresh:(id)sender {
}

- (void)recommendRequest {
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:_index];
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":_ad.uid, @"friId":[tmp objectForKey:@"friId"], @"friendNum":[NSString stringWithFormat:@"%ld", [_ad.storeFri1 count]]};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/main/recommendWithFri" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if(nil != responseObject) {
			NSArray *arr = [responseObject objectForKey:@"storeList"];
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"fristores" object:nil];
			NSLog(@"sl : %@", responseObject);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
}

- (IBAction)closePopup:(id)sender {
	self.recommendView.hidden = YES;
	self.closeModalBtn.hidden = NO;
	self.bottomView2.alpha = 1.0;
	self.topView.alpha = 1.0;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake && _checked) {
		self.recommendView.hidden = NO;
		
		[self recommendRequest];
		
//		self.recommendImage.image = [UIImage imageNamed:fileName];
		
		
		self.topView.alpha = 0.5;
		self.bottomView2.alpha = 0.5;
		self.closeModalBtn.hidden = YES;
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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self becomeFirstResponder];
	
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























