//
//  MyShopTapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopTapViewController.h"
#import "MyShopTableViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface MyShopTapViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MyShopTapViewController {
	AppDelegate *_ad;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"삭제";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
	MyShopTableViewController *mtvc = segue.destinationViewController;
	mtvc.loadedPage = indexPath.row;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	NSDictionary *tmp = [_ad.myBoardList objectAtIndex:indexPath.row];
	
	//	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	//	NSDictionary *parameters = @{@"id":_ad.uid, @"postingNum":[tmp objectForKey:@"postingNum"]};
	//	[manager POST:@"http://samchon.ygw3429.cloulu.com/write/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
	////		_ad.myBoardList = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"myStoreList"]];
	//		[_ad.myBoardList removeObjectAtIndex:indexPath.row];
	//	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	//		NSLog(@"Error: %@", error);
	//	}];
	[_ad.myBoardList removeObjectAtIndex:indexPath.row];
	NSArray *rows = [NSArray arrayWithObject:indexPath];
	
	[tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_ad.myBoardList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHOP_CELL"];
	
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SHOP_CELL"];
	
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary *tmp = [_ad.myBoardList objectAtIndex:indexPath.row];
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 16, 60, 60)];
//	imageView.image = img;
	imageView.tag = 126;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(89, 10, 150, 20)];
//	rname.text = [tmp objectForKey:@"storeName"];
	rname.font = [UIFont systemFontOfSize:13];
	rname.tag = 123;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(99, 30, 200, 20)];
//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.font = [UIFont systemFontOfSize:10];
	raddr.tag = 124;
	
	UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(210, 10, 50, 20)];
//	rdate.text = [tmp objectForKey:@"regDate"];
	rdate.font = [UIFont systemFontOfSize:9];
	rdate.textAlignment=NSTextAlignmentRight;
	rdate.tag = 125;
	
	UILabel *rcomment = [[UILabel alloc] initWithFrame:CGRectMake(89, 50, 200, 20)];
	//	raddr.text = [tmp objectForKey:@"storeAddr"];
	rcomment.font = [UIFont systemFontOfSize:10];
	rcomment.tag = 127;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
	[cell.contentView addSubview:rdate];
	[cell.contentView addSubview:rcomment];
	
	((UIImageView *)[cell.contentView viewWithTag:126]).image = img;
	((UILabel *)[cell.contentView viewWithTag:123]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:124]).text = [tmp objectForKey:@"storeAddr"];
	((UILabel *)[cell.contentView viewWithTag:125]).text = [tmp objectForKey:@"regDate"];
	((UILabel *)[cell.contentView viewWithTag:127]).text = [tmp objectForKey:@"userMemo"];

	
	return cell;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.table reloadData];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























