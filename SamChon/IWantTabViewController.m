//
//  IWantTabViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "IWantTabViewController.h"
#import "AppDelegate.h"

@interface IWantTabViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation IWantTabViewController {
	AppDelegate *_ad;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[_ad.myPicks removeObjectAtIndex:indexPath.row];
	NSArray *rows = [NSArray arrayWithObject:indexPath];
	
	[tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"삭제";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_ad.myPicks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WANT_CELL"];
	
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary *tmp = [_ad.myPicks objectAtIndex:indexPath.row];
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
	//	imageView.image = img;
	imageView.tag = 155;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
	//	rname.text = [tmp objectForKey:@"storeName"];
	rname.tag = 153;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
	//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.tag = 154;
	
//	UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 50, 20)];
//	//	rdate.text = [tmp objectForKey:@"regDate"];
//	rdate.textAlignment=NSTextAlignmentRight;
//	rdate.tag = 125;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
//	[cell.contentView addSubview:rdate];
	
	((UIImageView *)[cell.contentView viewWithTag:155]).image = img;
	((UILabel *)[cell.contentView viewWithTag:153]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:154]).text = [tmp objectForKey:@"storeAddr"];
//	((UILabel *)[cell.contentView viewWithTag:125]).text = [tmp objectForKey:@"regDate"];

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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.table reloadData];
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































