//
//  MyPageViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyPageViewController.h"

@interface MyPageViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIView *MyShop;
@property (weak, nonatomic) IBOutlet UIView *FirstFriends;
@property (weak, nonatomic) IBOutlet UIView *IWant;

@end

@implementation MyPageViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
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





































