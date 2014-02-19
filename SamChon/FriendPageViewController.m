//
//  FriendPageViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "FriendPageViewController.h"
#import "AppDelegate.h"
#import "FriendMapViewController.h"
#import "FriendShopViewController.h"

@interface FriendPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *friNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firPicView;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FriendPageViewController {
	AppDelegate *_ad;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
//	FriendMapViewController *fmvc = (FriendMapViewController *)segue.destinationViewController;
//	fmvc.friId = self.friId;
	
	FriendShopViewController *fsvc = (FriendShopViewController *)segue.destinationViewController;
	fsvc.friId = self.friId;
	fsvc.loadedPage = indexPath.row;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_ad.friStores count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRIEND_CELL"];
	
	NSDictionary *tmp = [_ad.friStores objectAtIndex:indexPath.row];
	
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
//	imageView.image = img;
	imageView.tag = 141;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
//	rname.text = [tmp objectForKey:@"storeName"];
	rname.tag = 142;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.tag = 143;
	
	UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 50, 20)];
//	rdate.text = [tmp objectForKey:@"regDate"];
	rdate.textAlignment=NSTextAlignmentRight;
	rdate.tag = 144;
		
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
	[cell.contentView addSubview:rdate];
	
	((UIImageView *)[cell.contentView viewWithTag:141]).image = img;
	((UILabel *)[cell.contentView viewWithTag:142]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:143]).text = [tmp objectForKey:@"storeAddr"];
	((UILabel *)[cell.contentView viewWithTag:144]).text = [tmp objectForKey:@"regDate"];
	
	return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showFriendInfo {
	NSURL *url = [NSURL URLWithString:[_ad.friPic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	self.firPicView.image = img;
	self.friNameLabel.textAlignment = NSTextAlignmentCenter;
	self.friNameLabel.text = self.friName;
	
	[self.table reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFriendInfo) name:@"fristores" object:nil];
	
	[_ad getFriendStores:self.friId];
	

}

- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
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






























