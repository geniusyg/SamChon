//
//  RecommendViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "RecommendViewController.h"
#define IMAGE_NUM 9

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
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation RecommendViewController {
	NSMutableArray *_images;
	NSArray *_names;
}
- (IBAction)closePopup:(id)sender {
	self.recommendView.hidden = YES;
	self.closeModalBtn.hidden = NO;
	self.bottomView.alpha = 1.0;
	self.topView.alpha = 1.0;
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		self.recommendView.hidden = NO;
		NSInteger rnd = (int)(arc4random()%9);
		NSString *fileName = [NSString stringWithFormat:@"img%d.jpg",rnd];
		self.recommendImage.image = [UIImage imageNamed:fileName];
		self.topView.alpha = 0.5;
		self.bottomView.alpha = 0.5;
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
	
	_images = [NSMutableArray array];
	
	for(int i=0; i<9; i++) {
		NSString *fileName = [NSString stringWithFormat:@"image%d",i];
		NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
		UIImage *image = [UIImage imageWithContentsOfFile:filePath];
		
		[_images addObject:image];
	}
	
	_names = @[@"채윤기",@"강대철",@"김보라",@"전경민",@"김한준",@"아해은",@"이종은",@"카르딕",@"넥서스"];
}

- (void) imageTapped:(UITapGestureRecognizer *)gr {	
	UIImageView *theTappedImageView = (UIImageView *)gr.view;
	NSInteger tag = theTappedImageView.tag - 100;
	
	NSString *fileName = [NSString stringWithFormat:@"image%d",tag];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
	UIImage *image = [UIImage imageWithContentsOfFile:filePath];
	
	self.imageView.image = image;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self becomeFirstResponder];
	
	CGFloat scrollWidth = 10.f;
	for (int i = 0; i<9; i++) {
		UIImageView *theView = [[UIImageView alloc] initWithFrame:
								CGRectMake(scrollWidth, 0, 80, 80)];
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollWidth+10, 90, 60, 20)];
		nameLabel.text = [_names objectAtIndex:i];
		
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
		
		singleTap.numberOfTapsRequired = 1;
		theView.userInteractionEnabled = YES;
		theView.tag = i + 100;
		[theView addGestureRecognizer:singleTap];
		
		theView.image = [_images objectAtIndex:i];
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





























