//
//  MyShopTableViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 29..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopTableViewController.h"

@interface MyShopTableViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property UITextField *replyTextField;

@end

@implementation MyShopTableViewController {
	NSMutableArray *_images;
	NSMutableArray *_replys[9];
	UIScrollView *_sv;
	UIPageControl *_pc;
}
- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)write:(id)sender {
	[self writeReply];
	[self.replyTextField resignFirstResponder];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.table.separatorColor = [UIColor clearColor];
	
	_images = [[NSMutableArray alloc] init];
	
	_replys[0] = [NSMutableArray arrayWithObjects:@"AA",@"BB",@"CC",@"DD",@"EE", nil];
	_replys[1] = [NSMutableArray arrayWithObjects:@"FF",@"GG",@"HH",@"II",@"JJ", nil];
	_replys[2] = [NSMutableArray arrayWithObjects:@"KK",@"LL",@"MM",@"NN",@"EE", nil];
	_replys[3] = [NSMutableArray arrayWithObjects:@"OO",@"PP",@"QQ",@"RR",@"EE", nil];
	_replys[4] = [NSMutableArray arrayWithObjects:@"SS",@"TT",@"UU",@"VV",@"WW", nil];
	_replys[5] = [NSMutableArray arrayWithObjects:@"XX",@"YY",@"ZZ",@"AA",@"BB", nil];
	_replys[6] = [NSMutableArray arrayWithObjects:@"CC",@"BB",@"AA",@"DD",@"EE", nil];
	_replys[7] = [NSMutableArray arrayWithObjects:@"HH",@"GG",@"FF",@"GG",@"HH", nil];
	_replys[8] = [NSMutableArray arrayWithObjects:@"MM",@"NN",@"OO",@"TT",@"QQ", nil];
	
	for(int i=0; i<9; i++) {
		NSString *tmp = [NSString stringWithFormat:@"img%d", i];
		UIImage *img = [UIImage imageNamed:[tmp stringByAppendingString:@".jpg"]];
		[_images addObject:img];
	}
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	
	int i=0;
	for (; i<9; i++) {
		UIImageView *imgView = [[UIImageView alloc] initWithImage:[_images objectAtIndex:i]];
		imgView.frame = CGRectMake(_sv.frame.size.width*i, 0, _sv.frame.size.width, _sv.frame.size.height);
		
		[_sv addSubview:imgView];
	}
	
	[_sv setContentSize:CGSizeMake(_sv.frame.size.width * i, _sv.frame.size.height)];
		
	_sv.showsVerticalScrollIndicator=NO;
	_sv.showsHorizontalScrollIndicator=YES;
	_sv.alwaysBounceVertical=NO;
	_sv.alwaysBounceHorizontal=NO;
	_sv.pagingEnabled=YES;
	_sv.delegate=self;
	
	_pc = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 230, 100, 20)];
	_pc.currentPage = self.loadedPage;
	_pc.numberOfPages = 9;
	[_pc addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
	
	[_sv setContentOffset:CGPointMake((_sv.frame.size.width * self.loadedPage), 0)];

	
	self.replyTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, 250, 30)];
	self.replyTextField.delegate = self;
	[self.replyTextField resignFirstResponder];
	self.replyTextField.placeholder = @"식당에 대한 댓글을 입력해 주세요!";
	self.replyTextField.backgroundColor = [UIColor whiteColor];
}

- (void)pageChangeValue:(id)sender {
	UIPageControl *pControl = (UIPageControl *) sender;
	[_sv setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if(![scrollView isKindOfClass:[self.table class]]) {
		CGFloat pageWidth = scrollView.frame.size.width;
		_pc.currentPage = floor((scrollView.contentOffset.x - pageWidth / 9) / pageWidth) + 1;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.replyTextField.text = @"";
	[self.table reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)writeReply {
	NSString *reply = self.replyTextField.text;
	if([reply length] > 0) {
	NSLog(@"%@", reply);
	self.replyTextField.text = @"";
	} else {
		return;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 73;
		case 1:
			return 250;
		case 2:
			return 50;
		case 3:
			return 50;
			
		default:
			break;
	}
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
		case 0:
		case 1:
		case 2:
			return 1;
		case 3:
			return [_replys[_pc.currentPage] count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:@"TITLE_CELL"];
			break;
		case 1: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"SCROLL_CELL"];
						
			[cell addSubview:_sv];
			[cell addSubview:_pc];
			break;
		}
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL"];
			[cell addSubview:self.replyTextField];
			break;
		case 3: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL"];
			cell.textLabel.text = [_replys[_pc.currentPage] objectAtIndex:indexPath.row];
		}
			break;
		default:
			break;
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_sv flashScrollIndicators];
}


@end




































