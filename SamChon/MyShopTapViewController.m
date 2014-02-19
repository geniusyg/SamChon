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
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
//	imageView.image = img;
	imageView.tag = 126;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
//	rname.text = [tmp objectForKey:@"storeName"];
	rname.tag = 123;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.tag = 124;
	
	UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 50, 20)];
//	rdate.text = [tmp objectForKey:@"regDate"];
	rdate.textAlignment=NSTextAlignmentRight;
	rdate.tag = 125;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
	[cell.contentView addSubview:rdate];
	
	((UIImageView *)[cell.contentView viewWithTag:126]).image = img;
	((UILabel *)[cell.contentView viewWithTag:123]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:124]).text = [tmp objectForKey:@"storeAddr"];
	((UILabel *)[cell.contentView viewWithTag:125]).text = [tmp objectForKey:@"regDate"];
	
	
//	for(UIView *v in [cell subviews])
//	{
//		if([v isKindOfClass:[UILabel class]])
//			[v removeFromSuperview];
//	}
//	
//	for(UIImageView *v in [cell subviews])
//	{
//		if([v isKindOfClass:[UIImageView class]])
//			[v removeFromSuperview];
//	}
//	
//	[cell addSubview:imageView];
//	[cell addSubview:rname];
//	[cell addSubview:raddr];
//	[cell addSubview:rdate];
	
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





























