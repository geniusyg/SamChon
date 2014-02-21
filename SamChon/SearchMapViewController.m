//
//  SearchMapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 21..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SearchMapViewController.h"
#import "TMapView.h"
#import "AppDelegate.h"

#define TMAPID @"40150fac-a4cc-3225-b772-0fdf01f0075e"


@interface SearchMapViewController () <TMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property TMapView *mapView;

@end

@implementation SearchMapViewController {
	AppDelegate *_ad;
}
- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
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
		[marker setIcon:[UIImage imageNamed:@"poi_b.png"]];
		
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
		[marker setIcon:[UIImage imageNamed:@"poi.png"]];
		
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
		[marker setIcon:[UIImage imageNamed:@"poi_y.png"]];
		
		[marker setCanShowCallout:YES];
		
		[marker setCalloutTitle:[tmp objectForKey:@"storeName"]];
		[marker setCalloutSubtitle:[tmp objectForKey:@"storeAddr"]];
		[marker setCalloutRightButtonImage:[UIImage imageNamed:@"rightBtn2.png"]];
		
		[_mapView addCustomObject:marker ID:markerID];
	}
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
	
	CGRect rect = CGRectMake(0, 0, 320, 498);
	
	_mapView = [[TMapView alloc] initWithFrame:rect];
	[_mapView setSKPMapApiKey:TMAPID];
	
	_mapView.delegate = self;
	
	[self.viewMap insertSubview:_mapView atIndex:0];
	
	TMapPoint * point =	[[TMapPoint alloc] initWithLon:[_ad.currentLng doubleValue] Lat:[_ad.currentLat doubleValue]];
	
	[_mapView setCenterPoint:point];
	
	TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
	[marker setTMapPoint:point];
	[marker setIcon:[UIImage imageNamed:@"myplace_b.png"]];
	
	[_mapView addCustomObject:marker ID:@"current_myMap"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


































