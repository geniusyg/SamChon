//
//  ShopInfoViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 17..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface ShopInfoViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *shopName;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSDictionary *storeInfo;

@property UITextField *replyTextField;
@property UIButton *heart;

@end

@implementation ShopInfoViewController {
	AppDelegate *_ad;
	NSMutableArray *_images;
	NSMutableArray *_rmenus;
	NSMutableArray *_postingIDs;
	
	UIScrollView *_sv;
	UIPageControl *_pc;
	int dy;
}

- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)writeReply:(id)sender {
	NSString *reply = self.replyTextField.text;
	if([reply length] > 0) {
		[_ad writeShopReplys:self.replyTextField.text];
		self.replyTextField.text = @"";
		
		[_ad getShopReplys];
		
		[self.table reloadData];
	} else {
		return;
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	switch (indexPath.section) {
		case 0: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"SCROLL_CELL3"];
			
			[cell addSubview:_sv];
			[cell addSubview:_pc];
			break;
		}
		case 1: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"FRIENDS_CELL3"];
			break;
		}
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL3"];
			[cell addSubview:self.replyTextField];
			break;
		case 3: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL3"];
			NSDictionary *tmp = [_ad.reply objectAtIndex:indexPath.row];
			cell.textLabel.text = [tmp objectForKey:@"repMemo"];
		}
			break;
		default:
			break;
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows;
	switch (section) {
		case 0:
		case 1:
		case 2:
			numberOfRows = 1;
			break;
		case 3:
			numberOfRows = [_ad.reply count];
		default:
			numberOfRows = 1;
			break;
	}
	
	return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 300;
		case 1:
		case 2:
		case 3:
			return 50;
			
		default:
			break;
	}
	
	return 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showReply {
	[self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	NSLog(@"%@", self._selectedID);
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStores) name:@"shopInfo" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showReply) name:@"store_reply" object:nil];
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	
	[_ad getStoreInfo:self._selectedID];
	[_ad getShopReplys];
	
//	self.shopName.text = [_ad.storeInfo objectForKey:@"storeName"];
//	
//	_images = [[NSMutableArray alloc] init];
//	_rmenus = [[NSMutableArray alloc] init];
//	_postingIDs = [[NSMutableArray alloc] init];
//	
//	NSArray *arr = [_ad.storeInfo objectForKey:@"storePic"];
//	
//		for(int i=0; i<[arr count]; i++) {		
//		NSDictionary *tmp = [arr objectAtIndex:i];
//		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
//		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//		
//		[_images addObject:url];
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
//	for (; i<[[_ad.storeInfo objectForKey:@"storePic"] count]; i++) {
//		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height)];
//		
//		[imgView setImageWithURL:[_images objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"question-75.png"]];
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
//	_pc.currentPage = 1;
//	_pc.numberOfPages = [_ad.friStores count];
//	[_pc addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
//	
//	[_sv setContentOffset:CGPointMake((_sv.frame.size.width * 1), 0)];
//	
//	self.replyTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, 250, 30)];
//	self.replyTextField.delegate = self;
//	[self.replyTextField resignFirstResponder];
//	self.replyTextField.placeholder = @"식당에 대한 댓글을 입력해 주세요!";
//	self.replyTextField.backgroundColor = [UIColor whiteColor];
//	
//	self.heart = [[UIButton alloc] initWithFrame:CGRectMake(250, 15, 50, 20)];
//	
//	if([@"0" isEqualToString:[_ad.storeInfo objectForKey:@"isLike"]]) {
//		[self.heart setTitle:@"안찜" forState:UIControlStateNormal];
//		[self.heart addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchDown];
//	} else {
//		[self.heart setTitle:@"찜" forState:UIControlStateNormal];
//		[self.heart addTarget:self action:@selector(unPick:) forControlEvents:UIControlEventTouchDown];
//	}

}

//- (void)getStoreInfo2:(NSString *)storeID {
//	
//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	NSDictionary *parameters = @{@"storeId":storeID, @"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
//	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/shopInfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		if(nil != responseObject) {
////			self.storeInfo_reply = [responseObject objectForKey:@"reply"];
//			
//			NSLog(@"%@", responseObject);
//			self.storeInfo = (NSDictionary *)responseObject;
//			
//			[[NSNotificationCenter defaultCenter] postNotificationName:@"shopInfo" object:nil];
//		}
//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		NSLog(@"Error: %@", error);
//	}];
//}


- (void)pick:(UIButton *) sender {
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"storeId":[_ad.storeInfo objectForKey:@"storeId"], @"status":@"1"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success liked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"찜" forState:UIControlStateNormal];
//	_ad.storeInfo_isLike = @"1";
	[_ad getMyBoardList];
	[_ad getMyPick];
}

- (void)unPick:(UIButton *) sender {
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"], @"storeId":[_ad.storeInfo objectForKey:@"storeId"], @"status":@"0"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success unliked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"안찜" forState:UIControlStateNormal];
//	_ad.storeInfo_isLike = @"0";
	[_ad getMyBoardList];
	[_ad getMyPick];
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

- (void)showStores {
	
	self.shopName.text = [_ad.storeInfo objectForKey:@"storeName"];
	
	_images = [[NSMutableArray alloc] init];
	_rmenus = [[NSMutableArray alloc] init];
	_postingIDs = [[NSMutableArray alloc] init];
	
	NSArray *arr = [_ad.storeInfo objectForKey:@"storePic"];
	
	for(int i=0; i<[arr count]; i++) {
		NSDictionary *tmp = [arr objectAtIndex:i];
		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		[_images addObject:url];
		[_rmenus addObject:[tmp objectForKey:@"menuName"]];
		
		[_postingIDs addObject:[tmp objectForKey:@"postingNum"]];
	}
	
	self.table.separatorColor = [UIColor clearColor];
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	
	int i=0;
	for (; i<[[_ad.storeInfo objectForKey:@"storePic"] count]; i++) {
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height)];
		
		[imgView setImageWithURL:[_images objectAtIndex:i] placeholderImage:[UIImage imageNamed:@"question-75.png"]];
		
		UILabel *rmenu = [[UILabel alloc] initWithFrame:CGRectMake(_sv.frame.size.width*i + 20, 30, _sv.frame.size.width - 40, 20)];
		rmenu.textAlignment = NSTextAlignmentCenter;
		rmenu.text = [_rmenus objectAtIndex:i];
		
		[_sv addSubview:imgView];
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
	_pc.currentPage = 1;
	_pc.numberOfPages = [_ad.friStores count];
	[_pc addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
	
	[_sv setContentOffset:CGPointMake((_sv.frame.size.width * 1), 0)];
	
	self.replyTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, 250, 30)];
	self.replyTextField.delegate = self;
	[self.replyTextField resignFirstResponder];
	self.replyTextField.placeholder = @"식당에 대한 댓글을 입력해 주세요!";
	self.replyTextField.backgroundColor = [UIColor whiteColor];
	
	self.heart = [[UIButton alloc] initWithFrame:CGRectMake(250, 15, 50, 20)];
	
	if([@"0" isEqualToString:[_ad.storeInfo objectForKey:@"isLike"]]) {
		[self.heart setTitle:@"안찜" forState:UIControlStateNormal];
		[self.heart addTarget:self action:@selector(pick:) forControlEvents:UIControlEventTouchDown];
	} else {
		[self.heart setTitle:@"찜" forState:UIControlStateNormal];
		[self.heart addTarget:self action:@selector(unPick:) forControlEvents:UIControlEventTouchDown];
	}

	
	[self.table reloadData];
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



































