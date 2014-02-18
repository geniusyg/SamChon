//
//  MyShopTableViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 29..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ModifyViewController.h"

#define COUNT 5

@interface MyShopTableViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property UITextField *replyTextField;
@end

@implementation MyShopTableViewController {
	AppDelegate *_ad;
	NSArray *aa;
	NSMutableArray *_images;
	NSMutableArray *_rnames;
	NSMutableArray *_rmenus;
	NSMutableArray *_storeIDs;
	NSMutableArray *_postingIDs;
	NSMutableArray *_replys;
	UIScrollView *_sv;
	UIPageControl *_pc;
	
	NSMutableArray *_arr[COUNT];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ModifyViewController *mvc = (ModifyViewController *)segue.destinationViewController;
	mvc.index = _pc.currentPage;
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
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	_images = [[NSMutableArray alloc] init];
	_rnames = [[NSMutableArray alloc] init];
	_rmenus = [[NSMutableArray alloc] init];
	_replys = [[NSMutableArray alloc] init];
	
	_storeIDs = [[NSMutableArray alloc] init];
	_postingIDs = [[NSMutableArray alloc] init];
	
	for(NSArray *arr in _ad.myBoardList) {
		NSDictionary *tmp = (NSDictionary *)arr;
		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [UIImage imageWithData:data];
		[_images addObject:img];
		[_rnames addObject:[tmp objectForKey:@"storeName"]];
		[_rmenus addObject:[tmp objectForKey:@"menuName"]];
//		[_storeIDs addObject:[tmp objectForKey:@"storeId"]];
//		[_postingIDs addObject:[tmp objectForKey:@"postingNum"]];
		
//		NSArray *arr = [_ad getReplys:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
//		NSLog(@"inside - %@", arr);
		
		
//		NSDictionary *nsd = [arr objectAtIndex:0];
//		NSLog(@"%@", nsd);
//		[_replys addObject:arr];
		//NSLog(@"%@", [arr objectAtIndex:1]);
	}
	
	self.table.separatorColor = [UIColor clearColor];
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	
	int i=0;
	for (; i<[_ad.myBoardList count]; i++) {
		UIImageView *imgView = [[UIImageView alloc] initWithImage:[_images objectAtIndex:i]];
		imgView.frame = CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height);
		
		UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 0, _sv.frame.size.width - 40, 20)];
		rname.textAlignment = NSTextAlignmentCenter;
		rname.text = [_rnames objectAtIndex:i];
		
		UILabel *rmenu = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 30, _sv.frame.size.width - 40, 20)];
		rmenu.textAlignment = NSTextAlignmentCenter;
		rmenu.text = [_rmenus objectAtIndex:i];
		
		[_sv addSubview:imgView];
		[_sv addSubview:rname];
		[_sv addSubview:rmenu];
		
	}
	
	[_sv setContentSize:CGSizeMake(_sv.frame.size.width * i, _sv.frame.size.height)];
	
	_sv.showsVerticalScrollIndicator=NO;
	_sv.showsHorizontalScrollIndicator=YES;
	_sv.alwaysBounceVertical=NO;
	_sv.alwaysBounceHorizontal=NO;
	_sv.pagingEnabled=YES;
	_sv.delegate=self;
	
	_pc = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 280, 100, 20)];
	_pc.currentPage = self.loadedPage;
	_pc.numberOfPages = [_ad.myBoardList count];
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
	if(![scrollView isKindOfClass:[self.table class]]) {
		self.replyTextField.text = @"";		
		
		[self.table reloadData];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)writeReply {
	NSString *reply = self.replyTextField.text;
	if([reply length] > 0) {
		[_ad writeReplys:[_postingIDs objectAtIndex:_pc.currentPage] comment:self.replyTextField.text];
		self.replyTextField.text = @"";
		[self.table reloadData];
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
			return 300;
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
//			NSArray *tmp = [NSArray arrayWithArray:[_replys objectAtIndex:_pc.currentPage]];
//			return [tmp count];
//		}
//			NSLog(@"%ld", [_replys count]);
//			return [_replys count];
			return 1;
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"TITLE_CELL"];
			UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.center.x-25, cell.center.y-25, 55, 55)];
			NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"upic"]];
			
			UIImage *imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url ]];
			
			profileImage.image = imgWeb;
			
			UIImageView *profileImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(cell.center.x-25, cell.center.y-25, 55, 55)];
			profileImage2.image = [UIImage imageNamed:@"Blank_2.png"];
			
			[cell addSubview:profileImage];
			[cell addSubview:profileImage2];
		}
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
//			cell.textLabel.text = [_replys[_pc.currentPage] objectAtIndex:indexPath.row];
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




































