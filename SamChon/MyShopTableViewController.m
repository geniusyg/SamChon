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
#import "UIImageView+AFNetworking.h"

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
	NSMutableArray *_likes;
	NSMutableArray *_comments;

	UIScrollView *_sv;
	UIPageControl *_pc;
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
	_likes = [[NSMutableArray alloc] init];
	_comments = [[NSMutableArray alloc] init];
	
	_storeIDs = [[NSMutableArray alloc] init];
	_postingIDs = [[NSMutableArray alloc] init];
	
	for(NSArray *arr in _ad.myBoardList) {
		NSDictionary *tmp = (NSDictionary *)arr;
		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		[_images addObject:url];
		[_rnames addObject:[tmp objectForKey:@"storeName"]];
		[_rmenus addObject:[tmp objectForKey:@"menuName"]];
		[_likes addObject:[tmp objectForKey:@"isLike"]];
		[_storeIDs addObject:[tmp objectForKey:@"storeId"]];
		[_postingIDs addObject:[tmp objectForKey:@"postingNum"]];
		[_comments addObject:[tmp objectForKey:@"userMemo"]];
	}
	
	self.table.separatorColor = [UIColor clearColor];
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	
	int i=0;
	for (; i<[_ad.myBoardList count]; i++) {
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height)];
		[imgView setImageWithURL:[_images objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"question-75.png"]];
		
		UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 0, _sv.frame.size.width - 40, 20)];
		rname.textAlignment = NSTextAlignmentCenter;
		rname.text = [_rnames objectAtIndex:i];
		
		UILabel *rmenu = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 30, _sv.frame.size.width - 40, 20)];
		rmenu.textAlignment = NSTextAlignmentCenter;
		rmenu.text = [_rmenus objectAtIndex:i];
		
		UIButton *heart = [[UIButton alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 250, 15, 50, 20)];
		heart.tag = 1000+i;
		
		if([@"0" isEqualToString:[_likes objectAtIndex:i]]) {
			[heart setTitle:@"안찜" forState:UIControlStateNormal];
			[heart addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchDown];
		} else {
			[heart setTitle:@"찜" forState:UIControlStateNormal];
			[heart addTarget:self action:@selector(unPick:) forControlEvents:UIControlEventTouchDown];
		}
			
		[_sv addSubview:imgView];
		[_sv addSubview:rname];
		[_sv addSubview:rmenu];
		[_sv addSubview:heart];
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
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReply) name:@"reply" object:nil];
}

- (void)pick:(UIButton *) sender {
	NSInteger index = sender.tag - 1000;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"storeId":[_storeIDs objectAtIndex:index], @"status":@"1"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success liked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"찜" forState:UIControlStateNormal];
	
	[_likes replaceObjectAtIndex:index withObject:@"1"];
	
	[_ad getMyBoardList];
	[_ad getMyPick];
}

- (void)unPick:(UIButton *) sender {
	NSInteger index = sender.tag - 1000;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"storeId":[_storeIDs objectAtIndex:index], @"status":@"0"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success unliked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"안찜" forState:UIControlStateNormal];
	
	[_likes replaceObjectAtIndex:index withObject:@"0"];
	
	[_ad getMyBoardList];
	[_ad getMyPick];
}

- (void)refreshReply {
	[self.table reloadData];
}

- (void)pageChangeValue:(id)sender {
	UIPageControl *pControl = (UIPageControl *) sender;
	[_sv setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if(![scrollView isKindOfClass:[self.table class]]) {
		CGFloat pageWidth = scrollView.frame.size.width;
		_pc.currentPage = floor((scrollView.contentOffset.x - pageWidth / [_ad.myBoardList count]) / pageWidth) + 1;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if(![scrollView isKindOfClass:[self.table class]]) {
		self.replyTextField.text = @"";		
		
		NSLog(@"%ld", _pc.currentPage);
		NSDictionary *tmp = [_ad.myBoardList objectAtIndex:_pc.currentPage];
		
		[_ad getReplys:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
		
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
		[_ad writeReplys:[_postingIDs objectAtIndex:_pc.currentPage] comment:reply];
		self.replyTextField.text = @"";
		NSDictionary *tmp = [_ad.myBoardList objectAtIndex:_pc.currentPage];
		
		[_ad getReplys:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
		
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
			return [_ad.reply count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"TITLE_CELL"];
			UIImageView *profileImage = [[UIImageView alloc] initWithFrame:CGRectMake(cell.center.x-25, cell.center.y-25, 61, 61)];
			NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"upic"]];
			
			UIImage *imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url ]];
			
			profileImage.image = imgWeb;
			
			profileImage.layer.cornerRadius = 30.0f;
			profileImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
			
			profileImage.layer.shouldRasterize = YES;
			profileImage.clipsToBounds = YES;
			
			[cell addSubview:profileImage];
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
			
			NSDictionary *tmp = [_ad.reply objectAtIndex:indexPath.row];
			UIImageView *replyPic = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 61, 61)];
			replyPic.layer.cornerRadius = 30.0f;
			replyPic.layer.rasterizationScale = [UIScreen mainScreen].scale;
			
			replyPic.layer.shouldRasterize = YES;
			replyPic.clipsToBounds = YES;
			
			cell.textLabel.text = [tmp objectForKey:@"repMemo"];
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
	
	NSDictionary *tmp = [_ad.myBoardList objectAtIndex:_pc.currentPage];
	
	[_ad getReplys:[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
	
	[self.table reloadData];

}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end




































