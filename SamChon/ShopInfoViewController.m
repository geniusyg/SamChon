////
////  ShopInfoViewController.m
////  SamChon
////
////  Created by SDT-1 on 2014. 2. 17..
////  Copyright (c) 2014년 T. All rights reserved.
////
//
//#import "ShopInfoViewController.h"
//#import "AppDelegate.h"
//#import "AFNetworking.h"
//
//@interface ShopInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UILabel *shopName;
//@property (weak, nonatomic) IBOutlet UITableView *table;
//
//@property UITextField *replyTextField;
//@property UIButton *heart;
//
//@end
//
//@implementation ShopInfoViewController {
//	AppDelegate *_ad;
//	NSMutableArray *_images;
//	NSMutableArray *_rmenus;
//	NSMutableArray *_postingIDs;
//	
//	UIScrollView *_sv;
//	UIPageControl *_pc;
//	int dy;
//}
//
//- (IBAction)closeModal:(id)sender {
//	[self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (IBAction)writeReply:(id)sender {
//	NSString *reply = self.replyTextField.text;
//	if([reply length] > 0) {
//		[_ad writeShopReplys:self.replyTextField.text];
//		self.replyTextField.text = @"";
//		
//		[_ad getShopReplys];
//		
//		[self.table reloadData];
//	} else {
//		return;
//	}
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	UITableViewCell *cell;
//	
//	switch (indexPath.section) {
//		case 0: {
//			cell = [tableView dequeueReusableCellWithIdentifier:@"SCROLL_CELL3"];
//			
//			[cell addSubview:_sv];
//			[cell addSubview:_pc];
//			break;
//		}
//		case 1:
//			cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL3"];
//			[cell addSubview:self.replyTextField];
//			break;
//		case 2: {
//			cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL3"];
//			NSDictionary *tmp = [_ad.reply objectAtIndex:indexPath.row];
//			cell.textLabel.text = [tmp objectForKey:@"repMemo"];
//		}
//			break;
//		default:
//			break;
//	}
//	
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	
//	return cell;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 4;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	NSInteger numberOfRows;
//	switch (section) {
//		case 0:
//		case 1:
//		case 2:
//			numberOfRows = 1;
//			break;
//		case 3:
//			numberOfRows = [_ad.storeInfo_reply count];
//		default:
//			numberOfRows = 1;
//			break;
//	}
//	
//	return numberOfRows;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	switch (indexPath.section) {
//		case 0:
//			return 300;
//		case 1:
//		case 2:
//		case 3:
//			return 50;
//			
//		default:
//			break;
//	}
//	
//	return 1;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//	
//	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStores) name:@"shopInfo" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStores) name:@"store_reply" object:nil];
//	
//	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//	
//	_images = [[NSMutableArray alloc] init];
//	_rmenus = [[NSMutableArray alloc] init];
//	_postingIDs = [[NSMutableArray alloc] init];
//	
//	for(NSArray *arr in _ad.storeInfo_storePic) {
//		
//		NSDictionary *tmp = (NSDictionary *)arr;
//		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
//		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//		NSData *data = [NSData dataWithContentsOfURL:url];
//		UIImage *img = [UIImage imageWithData:data];
//		
//		[_images addObject:img];
//		[_rmenus addObject:[tmp objectForKey:@"menuName"]];
//		
//		[_postingIDs addObject:[tmp objectForKey:@"postingNum"]];
//	}
//	
//	self.table.separatorColor = [UIColor clearColor];
//
//	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
//	
//	int i=0;
//	for (; i<[_ad.storeInfo_storePic count]; i++) {
//		UIImageView *imgView = [[UIImageView alloc] initWithImage:[_images objectAtIndex:i]];
//		imgView.frame = CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height);
//		
//		UILabel *rmenu = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 30, _sv.frame.size.width - 40, 20)];
//		rmenu.textAlignment = NSTextAlignmentCenter;
//		rmenu.text = [_rmenus objectAtIndex:i];
//		
//		[_sv addSubview:imgView];
//		[_sv addSubview:rmenu];
//	}
//	
//	[_sv setContentSize:CGSizeMake(_sv.frame.size.width * i, _sv.frame.size.height)];
//	
//	_sv.showsVerticalScrollIndicator=NO;
//	_sv.showsHorizontalScrollIndicator=YES;
//	_sv.alwaysBounceVertical=NO;
//	_sv.alwaysBounceHorizontal=NO;
//	_sv.pagingEnabled=YES;
//	_sv.delegate=self;
//	
//	_pc = [[UIPageControl alloc] initWithFrame:CGRectMake(100, 280, 100, 20)];
//	_pc.currentPage = self.loadedPage;
//	_pc.numberOfPages = [_ad.friStores count];
//	[_pc addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
//	
//	[_sv setContentOffset:CGPointMake((_sv.frame.size.width * self.loadedPage), 0)];
//	
//	self.replyTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, 250, 30)];
//	self.replyTextField.delegate = self;
//	[self.replyTextField resignFirstResponder];
//	self.replyTextField.placeholder = @"식당에 대한 댓글을 입력해 주세요!";
//	self.replyTextField.backgroundColor = [UIColor whiteColor];
//	
//	self.heart = [[UIButton alloc] initWithFrame:CGRectMake(250, 15, 50, 20)];
//	self.heart.tag = 1500+i;
//	
//	if([@"0" isEqualToString:_ad.storeInfo_isLike]) {
//		[self.heart setTitle:@"안찜" forState:UIControlStateNormal];
//		[self.heart addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchDown];
//	} else {
//		[self.heart setTitle:@"찜" forState:UIControlStateNormal];
//		[self.heart addTarget:self action:@selector(unPick:) forControlEvents:UIControlEventTouchDown];
//	}
//	
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshReply) name:@"reply" object:nil];
//}
//
//- (void)pick:(UIButton *) sender {
//	NSInteger index = sender.tag - 1500;
//	
//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	NSDictionary *parameters = @{@"id":_ad.uid, @"storeId":[_storeIDs objectAtIndex:index], @"status":@"1"};
//	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		NSLog(@"success liked");
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		NSLog(@"Error: %@", error);
//	}];
//	
//	[sender setTitle:@"찜" forState:UIControlStateNormal];
//	
//	[_likes replaceObjectAtIndex:index withObject:@"1"];
//	
//	[_ad getMyBoardList];
//	[_ad getMyPick];
//	[_ad getFriendStores:self.friId];
//}
//
//- (void)unPick:(UIButton *) sender {
//	NSInteger index = sender.tag - 1500;
//	
//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	NSDictionary *parameters = @{@"id":_ad.uid, @"storeId":[_storeIDs objectAtIndex:index], @"status":@"0"};
//	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		NSLog(@"success unliked");
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		NSLog(@"Error: %@", error);
//	}];
//	
//	[sender setTitle:@"안찜" forState:UIControlStateNormal];
//	
//	[_likes replaceObjectAtIndex:index withObject:@"0"];
//	
//	[_ad getMyBoardList];
//	[_ad getMyPick];
//	[_ad getFriendStores:self.friId];
//}
//
//- (void)pageChangeValue:(id)sender {
//	UIPageControl *pControl = (UIPageControl *) sender;
//	[_sv setContentOffset:CGPointMake(pControl.currentPage*320, 0) animated:YES];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	if(![scrollView isKindOfClass:[self.table class]]) {
//		CGFloat pageWidth = scrollView.frame.size.width;
//		_pc.currentPage = floor((scrollView.contentOffset.x - pageWidth / 9) / pageWidth) + 1;
//	}
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//	if(![scrollView isKindOfClass:[self.table class]]) {
//		self.replyTextField.text = @"";
//		
//		NSDictionary *tmp = [_ad.friStores objectAtIndex:_pc.currentPage];
//		
//		[_ad getReplys:self.friId storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
//		
//		[self.table reloadData];
//	}
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//	[textField resignFirstResponder];
//	return YES;
//}
//
//- (void)showStores {
//	[self.table reloadData];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//@end
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
