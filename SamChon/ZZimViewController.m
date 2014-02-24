//
//  ZZimViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ZZimViewController.h"
#import "ShopInfoViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ZZimViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ZZimViewController {
	AppDelegate *_ad;
	NSMutableArray *_images;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	ShopInfoViewController *sivc = (ShopInfoViewController *)segue.destinationViewController;
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
	NSDictionary *tmp = [_ad.myPicks objectAtIndex:indexPath.row];
	int tmpNum = [[tmp objectForKey:@"storeId"] intValue];
	NSLog(@"%d", tmpNum);
	sivc._selectedID = [NSString stringWithFormat:@"%d", tmpNum];
	_ad.storeId =[NSString stringWithFormat:@"%d", tmpNum];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_ad.myPicks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZZIM_CELL"];
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary *tmp = [_ad.myPicks objectAtIndex:indexPath.row];
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 60, 60)];
	imageView.tag = 155;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(89, 10, 150, 20)];
	//	rname.text = [tmp objectForKey:@"storeName"];
	rname.font = [UIFont systemFontOfSize:13];
	rname.tag = 153;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(99, 30, 200, 20)];
	//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.font = [UIFont systemFontOfSize:10];
	raddr.tag = 154;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
	//	[cell.contentView addSubview:rdate];
	
	
	[((UIImageView *)[cell.contentView viewWithTag:155]) setImageWithURL:url placeholderImage:[UIImage imageNamed:@"question-75.png"]];
	((UILabel *)[cell.contentView viewWithTag:153]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:154]).text = [tmp objectForKey:@"storeAddr"];
	//	((UILabel *)[cell.contentView viewWithTag:125]).text = [tmp objectForKey:@"regDate"];
	return cell;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"myPickList" object:nil];
	
	[_ad getMyPick];
	
	
	[self.table reloadData];
	}
}

- (void)refreshTable {
	
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
	
	_images = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

































