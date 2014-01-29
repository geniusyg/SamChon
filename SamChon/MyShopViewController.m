//
//  MyShopViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 28..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopViewController.h"

@interface MyShopViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *sc;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MyShopViewController {
	NSMutableArray *_data;
	NSMutableArray *_images;
	NSMutableArray *_titles;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 1;
		case 2:
			return [_data count];
	}
	
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:@"PICTURE_CELL"];
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL"];
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL"];
		default:
			break;
	}
	
	return cell;
}

- (IBAction)close:(id)sender {
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
	
	_data = [NSMutableArray arrayWithObjects:@"AA", @"BB", @"CC", @"DD", @"EE", @"FF", nil];
	_titles = [NSMutableArray arrayWithObjects:@"궁중떡볶이", @"김밥천국", @"왕가네", @"우리지금만나", @"아딸점", @"쭈꾸미", nil];
	
	_images = [NSMutableArray array];
	
	for(int i=0; i<9; i++) {
		NSString *fileName = [NSString stringWithFormat:@"img%d",i];
		NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
		UIImage *image = [UIImage imageWithContentsOfFile:filePath];
		
		[_images addObject:image];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
//	CGFloat scrollWidth = 10.f;
//	
//	for (int i = 0; i<9; i++) {
//		UIImageView *theView = [[UIImageView alloc] initWithFrame:
//								CGRectMake(scrollWidth, 0, 280, 280)];
//		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(scrollWidth+10, 10, 60, 20)];
//		nameLabel.text = [_titles objectAtIndex:i];
//		
//		[self.sv addSubview:theView];
//		[self.sv addSubview:nameLabel];
//		scrollWidth += 100;
//	}
//	
//	self.sv.contentSize = CGSizeMake(scrollWidth, 80);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
































