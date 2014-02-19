//
//  SearchViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SearchViewController.h"
#import "TMapView.h"
#import "AppDelegate.h"

#define TMAPID @"40150fac-a4cc-3225-b772-0fdf01f0075e"

@interface SearchViewController () <TMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *tableView2;

@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property TMapView *mapView;

@end

@implementation SearchViewController {
	AppDelegate *_ad;
	CLLocationManager *_lm;
	BOOL isTable;
}

- (IBAction)clickThird:(id)sender {
	for(int i=0; i<[_ad.recommendFri3 count]; i++) {
		NSDictionary *tmp = [_ad.recommendFri3 objectAtIndex:i];
		
		NSString *markerID = [NSString stringWithFormat:@"marker6_%d", i];
		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
		
		double dlat = [[tmp objectForKey:@"lat"] doubleValue];
		double dlng = [[tmp objectForKey:@"lng"] doubleValue];
		
		TMapPoint *point = [[TMapPoint alloc] initWithLon:dlng Lat:dlat];
		
		[marker setTMapPoint:point];
		[marker setIcon:[UIImage imageNamed:@"thirdPoint.png"]];
		
		[marker setCanShowCallout:YES];
		
		[marker setCalloutTitle:[tmp objectForKey:@"storeName"]];
		[marker setCalloutSubtitle:[tmp objectForKey:@"storeAddr"]];
		[marker setCalloutRightButtonImage:[UIImage imageNamed:@"rightBtn2.png"]];
		
		[_mapView addCustomObject:marker ID:markerID];
	}
}

- (IBAction)clickSecond:(id)sender {
	for(int i=0; i<[_ad.recommendFri2 count]; i++) {
		NSDictionary *tmp = [_ad.recommendFri2 objectAtIndex:i];
		
		NSString *markerID = [NSString stringWithFormat:@"marker6_%d", i];
		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
		
		double dlat = [[tmp objectForKey:@"lat"] doubleValue];
		double dlng = [[tmp objectForKey:@"lng"] doubleValue];
		
		TMapPoint *point = [[TMapPoint alloc] initWithLon:dlng Lat:dlat];
		
		[marker setTMapPoint:point];
		[marker setIcon:[UIImage imageNamed:@"secondPoint.png"]];
		
		[marker setCanShowCallout:YES];
		
		[marker setCalloutTitle:[tmp objectForKey:@"storeName"]];
		[marker setCalloutSubtitle:[tmp objectForKey:@"storeAddr"]];
		[marker setCalloutRightButtonImage:[UIImage imageNamed:@"rightBtn2.png"]];
		
		[_mapView addCustomObject:marker ID:markerID];
	}
}

- (IBAction)clickFirst:(id)sender {
	for(int i=0; i<[_ad.recommendFri1 count]; i++) {
		NSDictionary *tmp = [_ad.recommendFri1 objectAtIndex:i];
		
		NSString *markerID = [NSString stringWithFormat:@"marker5_%d", i];
		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
		
		double dlat = [[tmp objectForKey:@"lat"] doubleValue];
		double dlng = [[tmp objectForKey:@"lng"] doubleValue];
		
		TMapPoint *point = [[TMapPoint alloc] initWithLon:dlng Lat:dlat];
		
		[marker setTMapPoint:point];
		[marker setIcon:[UIImage imageNamed:@"point.png"]];
		
		[marker setCanShowCallout:YES];
		
		[marker setCalloutTitle:[tmp objectForKey:@"storeName"]];
		[marker setCalloutSubtitle:[tmp objectForKey:@"storeAddr"]];
		[marker setCalloutRightButtonImage:[UIImage imageNamed:@"rightBtn2.png"]];
		
		[_mapView addCustomObject:marker ID:markerID];
	}
}

- (IBAction)MapAndTable:(id)sender {
	if(isTable) {
		isTable = NO;
		self.tableView2.hidden = YES;
		self.mapView.hidden = NO;
		[self.switchBtn setTitle:@"리스트" forState:UIControlStateNormal];
		
		TMapPoint * point =	[[TMapPoint alloc] initWithLon:[_ad.currentLng doubleValue] Lat:[_ad.currentLat doubleValue]];
		
		[_mapView setCenterPoint:point];
		
		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
		[marker setTMapPoint:point];
		[marker setIcon:[UIImage imageNamed:@"currentPoint.png"]];
		
		[_mapView addCustomObject:marker ID:@"current_myMap"];
		
	} else {
		isTable = YES;
		self.mapView.hidden = YES;
		self.tableView2.hidden = NO;
		[self.switchBtn setTitle:@"지도" forState:UIControlStateNormal];
		[_mapView clearCustomObjects];
	}
}

- (void)onCalloutRightbuttonClick:(TMapMarkerItem *)markerItem {
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title;
	switch (section) {
		case 0:
			title = @"1촌";
			break;
		case 1:
			title = @"2촌";
			break;
		case 2:
			title = @"3촌";
			break;
		default:
			break;
	}
	return title;
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
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
			//	rname.text = [tmp objectForKey:@"storeName"];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
			//	raddr.text = [tmp objectForKey:@"storeAddr"];
			raddr.tag = 174;
			
			UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 50, 20)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			rdate.textAlignment=NSTextAlignmentRight;
			rdate.tag = 175;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:rdate];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UILabel *)[cell.contentView viewWithTag:175]).text = [tmp objectForKey:@"1촌 추천"];
		}
			break;
		case 1: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"RECOMMEND_CELL2"];
			
			NSDictionary *tmp = [_ad.recommendFri2 objectAtIndex:indexPath.row];
			NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
			NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [UIImage imageWithData:data];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
			//	rname.text = [tmp objectForKey:@"storeName"];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
			//	raddr.text = [tmp objectForKey:@"storeAddr"];
			raddr.tag = 174;
			
			UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 50, 20)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			rdate.textAlignment=NSTextAlignmentRight;
			rdate.tag = 175;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:rdate];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UILabel *)[cell.contentView viewWithTag:175]).text = [tmp objectForKey:@"2촌 추천"];
		}
			
			break;
		case 2: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"RECOMMEND_CELL3"];
			
			NSDictionary *tmp = [_ad.recommendFri3 objectAtIndex:indexPath.row];
			NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
			NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			NSData *data = [NSData dataWithContentsOfURL:url];
			UIImage *img = [UIImage imageWithData:data];
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
			//	imageView.image = img;
			imageView.tag = 176;
			
			UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
			//	rname.text = [tmp objectForKey:@"storeName"];
			rname.tag = 173;
			
			UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
			//	raddr.text = [tmp objectForKey:@"storeAddr"];
			raddr.tag = 174;
			
			UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(150, 50, 50, 20)];
			//	rdate.text = [tmp objectForKey:@"regDate"];
			rdate.textAlignment=NSTextAlignmentRight;
			rdate.tag = 175;
			
			[cell.contentView addSubview:imageView];
			[cell.contentView addSubview:rname];
			[cell.contentView addSubview:raddr];
			[cell.contentView addSubview:rdate];
			
			((UIImageView *)[cell.contentView viewWithTag:176]).image = img;
			((UILabel *)[cell.contentView viewWithTag:173]).text = [tmp objectForKey:@"storeName"];
			((UILabel *)[cell.contentView viewWithTag:174]).text = [tmp objectForKey:@"storeAddr"];
			((UILabel *)[cell.contentView viewWithTag:175]).text = [tmp objectForKey:@"3촌 추천"];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
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

- (IBAction)click1:(id)sender {
}
- (IBAction)click2:(id)sender {
}
- (IBAction)click3:(id)sender {
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
	
	_lm = [[CLLocationManager alloc] init];
	
	_lm.delegate = self;
	_lm.desiredAccuracy = kCLLocationAccuracyBest;
	_lm.distanceFilter = 1000.0f;
	[_lm startUpdatingLocation];
	
	CGRect rect = CGRectMake(0, 0, 320, 361);
	
	_mapView = [[TMapView alloc] initWithFrame:rect];
	[_mapView setSKPMapApiKey:TMAPID];
	
	_mapView.delegate = self;
	
	[self.viewMap insertSubview:_mapView atIndex:0];
	
	isTable = YES;
	self.mapView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























