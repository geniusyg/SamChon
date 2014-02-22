//
//  SearchViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation SearchViewController {
	AppDelegate *_ad;
	BOOL isTable;
}
- (IBAction)search:(id)sender {
	[self resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self resignFirstResponder];
	
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
//	[_mapView clearCustomObjects];
	
//	NSString *keyword = searchBar.text;
//	TMapPathData *path = [[TMapPathData alloc] init];
//	NSArray *result = [path requestFindTitlePOI:keyword];
//	
//	NSLog(@"number : %d", result.count);
//	
//	int i=0;
//	
//	for(TMapPOIItem *item in result) {
//		NSLog(@"Name %@ - Point %@", [item getPOIName], [item getPOIPoint]);
//		
//		NSString *markerID = [NSString stringWithFormat:@"marker_%d", i++];
//		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
//		[marker setTMapPoint:[item getPOIPoint]];
//		[marker setIcon:[UIImage imageNamed:@"point.png"]];
//		
//		[marker setCanShowCallout:YES];
//		[marker setCalloutTitle:[item getPOIName]];
//		[marker setCalloutSubtitle:[item getPOIAddress]];
//		
//		[_mapView addCustomObject:marker ID:markerID];
//	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"RECOMMEND_CELL1"];
			
			NSDictionary *tmp = [_ad.recommendFri1 objectAtIndex:indexPath.row];
			NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
			NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [UIImage imageWithData:data];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 60, 60)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(66, 38, 200, 20)];
			rname.font = [UIFont systemFontOfSize:13];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, 200, 20)];
			raddr.font = [UIFont systemFontOfSize:10];
			raddr.tag = 174;
			
			UIImageView *fsc = [[UIImageView alloc] initWithFrame:CGRectMake(66, 20, 61, 17)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			fsc.tag = 175;
			
			UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(270, 20, 20, 10)];
			count.font = [UIFont systemFontOfSize:10];
			count.tag = 177;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:fsc];
			[cell.contentView addSubview:count];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UIImageView *)[cell.contentView viewWithTag:175]).image = [UIImage imageNamed:@"1c.png"];
//			((UILabel *)[cell.contentView viewWithTag:177]).text = [tmp objectForKey:@"postCount"];
			((UILabel *)[cell.contentView viewWithTag:177]).text = @"123";
		}
			break;
		case 1: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"RECOMMEND_CELL2"];
			
			NSDictionary *tmp = [_ad.recommendFri2 objectAtIndex:indexPath.row];
			NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
			NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [UIImage imageWithData:data];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 60, 60)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, 200, 20)];
			rname.font = [UIFont systemFontOfSize:13];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, 200, 20)];
			raddr.font = [UIFont systemFontOfSize:10];
			raddr.tag = 174;
			
			UIImageView *fsc = [[UIImageView alloc] initWithFrame:CGRectMake(70, 20, 61, 17)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			fsc.tag = 175;
			
			UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(270, 20, 20, 10)];
			count.font = [UIFont systemFontOfSize:10];
			count.tag = 177;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:fsc];
			[cell.contentView addSubview:count];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UIImageView *)[cell.contentView viewWithTag:175]).image = [UIImage imageNamed:@"2c.png"];
			//			((UILabel *)[cell.contentView viewWithTag:177]).text = [tmp objectForKey:@"postCount"];
			((UILabel *)[cell.contentView viewWithTag:177]).text = @"123";
		}
			
			break;
		case 2: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"RECOMMEND_CELL3"];
			
			NSDictionary *tmp = [_ad.recommendFri3 objectAtIndex:indexPath.row];
			NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
			NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [UIImage imageWithData:data];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 60, 60)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(70, 38, 200, 20)];
			rname.font = [UIFont systemFontOfSize:13];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, 200, 20)];
			raddr.font = [UIFont systemFontOfSize:10];
			raddr.tag = 174;
			
			UIImageView *fsc = [[UIImageView alloc] initWithFrame:CGRectMake(70, 20, 61, 17)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			fsc.tag = 175;
			
			UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(270, 20, 20, 10)];
			count.font = [UIFont systemFontOfSize:10];
			count.tag = 177;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:fsc];
			[cell.contentView addSubview:count];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UIImageView *)[cell.contentView viewWithTag:175]).image = [UIImage imageNamed:@"3c.png"];
			//			((UILabel *)[cell.contentView viewWithTag:177]).text = [tmp objectForKey:@"postCount"];
			((UILabel *)[cell.contentView viewWithTag:177]).text = @"123";
		}
			
			break;
			
		default:
			break;
	}

	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [_ad.recommendFri1 count];
			break;
		case 1:
			return [_ad.recommendFri2 count];
			break;
		case 2:
			return [_ad.recommendFri3 count];
			break;
		default:
			break;
	}
	
	return 1;
}

- (void)refreshTable {
	[self.table reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"getFriendsList" object:nil];
	
	[_ad getRecommendList];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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





























