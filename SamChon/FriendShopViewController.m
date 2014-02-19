//
//  FriendShopViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "FriendShopViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface FriendShopViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property UITextField *replyTextField;
@end

@implementation FriendShopViewController {
	AppDelegate *_ad;
	NSArray *aa;
	NSMutableArray *_images;
	NSMutableArray *_rnames;
	NSMutableArray *_rmenus;
	NSMutableArray *_storeIDs;
	NSMutableArray *_postingIDs;
	NSMutableArray *_likes;
	
	UIScrollView *_sv;
	UIPageControl *_pc;
	int dy;
}
- (IBAction)writeReply:(id)sender {
	NSString *reply = self.replyTextField.text;
	if([reply length] > 0) {
		[_ad writeReplys:[_postingIDs objectAtIndex:_pc.currentPage] comment:reply];
		self.replyTextField.text = @"";
		NSDictionary *tmp = [_ad.friStores objectAtIndex:_pc.currentPage];
		
		[_ad getReplys:self.friId storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
		
		[self.table reloadData];
	} else {
		return;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		UITableViewCell *cell;
		
		switch (indexPath.section) {
			case 0: {
				cell = [tableView dequeueReusableCellWithIdentifier:@"SCROLL_CELL2"];
				
				[cell addSubview:_sv];
				[cell addSubview:_pc];
				break;
			}
			case 1:
				cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL2"];
				[cell addSubview:self.replyTextField];
				break;
			case 2: {
				cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL2"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSURL *url = [NSURL URLWithString:[_ad.friPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	self.userImageView.image = img;
	
	_images = [[NSMutableArray alloc] init];
	_rnames = [[NSMutableArray alloc] init];
	_rmenus = [[NSMutableArray alloc] init];
	_likes = [[NSMutableArray alloc] init];
	
	_storeIDs = [[NSMutableArray alloc] init];
	_postingIDs = [[NSMutableArray alloc] init];
	
	for(NSArray *arr in _ad.friStores) {
		NSDictionary *tmp = (NSDictionary *)arr;
		NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
		NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		NSData *data = [NSData dataWithContentsOfURL:url];
		UIImage *img = [UIImage imageWithData:data];
		
		[_images addObject:img];
		[_rnames addObject:[tmp objectForKey:@"storeName"]];
		[_likes addObject:[tmp objectForKey:@"isLike"]];
		[_rmenus addObject:[tmp objectForKey:@"menuName"]];
		
		
		[_storeIDs addObject:[tmp objectForKey:@"storeId"]];
		[_postingIDs addObject:[tmp objectForKey:@"postingNum"]];
	}
	
	self.table.separatorColor = [UIColor clearColor];
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	
	int i=0;
	for (; i<[_ad.friStores count]; i++) {
		UIImageView *imgView = [[UIImageView alloc] initWithImage:[_images objectAtIndex:i]];
		imgView.frame = CGRectMake(_sv.frame.size.width*i + 20, 50, _sv.frame.size.width - 40, _sv.frame.size.height);
		
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
	_pc.numberOfPages = [_ad.friStores count];
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
	NSDictionary *parameters = @{@"id":_ad.uid, @"storeId":[_storeIDs objectAtIndex:index], @"status":@"1"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success liked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"찜" forState:UIControlStateNormal];
	
	[_likes replaceObjectAtIndex:index withObject:@"1"];
	
	[_ad getMyBoardList];
	[_ad getMyPick];
	[_ad getFriendStores:self.friId];
}

- (void)unPick:(UIButton *) sender {
	NSInteger index = sender.tag - 1000;
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id":_ad.uid, @"storeId":[_storeIDs objectAtIndex:index], @"status":@"0"};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/shop/enrollmyPickList" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"success unliked");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[sender setTitle:@"안찜" forState:UIControlStateNormal];
	
	[_likes replaceObjectAtIndex:index withObject:@"0"];
	
	[_ad getMyBoardList];
	[_ad getMyPick];
	[_ad getFriendStores:self.friId];
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
		_pc.currentPage = floor((scrollView.contentOffset.x - pageWidth / 9) / pageWidth) + 1;
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if(![scrollView isKindOfClass:[self.table class]]) {
		self.replyTextField.text = @"";
		
		NSDictionary *tmp = [_ad.friStores objectAtIndex:_pc.currentPage];
		
		[_ad getReplys:self.friId storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
		
		[self.table reloadData];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 300;
		case 1:
			return 50;
		case 2:
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
			return 1;
		case 2:
			return [_ad.reply count];
	}
    return 0;
}

- (UITextField *)firstResponderTextField {
	for(id child in self.view.subviews){
		if([child isKindOfClass:[UITextField class]]){
			UITextField *textField = (UITextField *)child;
			if(textField.isFirstResponder) {
				return textField;
			}
		}
	}
	return nil;
}

- (void)keyboardWillShow:(NSNotification *)noti {
	
	UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
	int y = firstResponder.frame.origin.y + firstResponder.frame.size.height+5+450;
	int viewHeight = self.view.frame.size.height;
	
	NSDictionary *userInfo = [noti userInfo];
	CGRect rect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	int keyboardHeight = (int)rect.size.height;
	
	float ani = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	
	if(keyboardHeight > (viewHeight - y)){
		[UIView animateWithDuration:ani animations:^{
			dy = keyboardHeight - (viewHeight -y);
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y-dy);
		}];
	} else {
		dy = 0;
	}
}

- (void)keyboardWillHide:(NSNotification *)noti {
	
	if(dy>0) {
		float ani = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
		[UIView animateWithDuration:ani animations:^{
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + dy);
		}];
	}
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[_sv flashScrollIndicators];
	
	NSDictionary *tmp = [_ad.friStores objectAtIndex:_pc.currentPage];
	
	[_ad getReplys:self.friId storeID:[tmp objectForKey:@"storeId"] postingNum:[tmp objectForKey:@"postingNum"]];
	
	[self.table reloadData];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



















