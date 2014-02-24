//
//  StoreMapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "StoreMapViewController.h"
#import "TMapView.h"
#import "AppDelegate.h"

#define TMAPID @"40150fac-a4cc-3225-b772-0fdf01f0075e"

@interface StoreMapViewController () <TMapViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewMap;

@end

@implementation StoreMapViewController {
	AppDelegate *_ad;
	TMapView *_mapView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	_mapView = [[TMapView alloc] initWithFrame:CGRectMake(0, 0, 320, self.viewMap.frame.size.height)];
	[_mapView setSKPMapApiKey:TMAPID];
	
	_mapView.delegate = self;
	
	TMapPoint *point =	[[TMapPoint alloc] initWithLon:[_ad.currentLng doubleValue] Lat:[_ad.currentLat doubleValue]];
	
	TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
	[marker setTMapPoint:point];
	[marker setIcon:[UIImage imageNamed:@"myplace_b.png"]];
	
	[_mapView addCustomObject:marker ID:@"current_myMap"];
		
	NSString *markerID = @"storeMap";
	marker = [[TMapMarkerItem alloc] init];
	
	double lat = [[_ad.storeMapInfo objectForKey:@"lat"] doubleValue];
	double lng = [[_ad.storeMapInfo objectForKey:@"lng"] doubleValue];
		
	point = [[TMapPoint alloc] initWithLon:lng Lat:lat];
		
	[marker setTMapPoint:point];
	[marker setIcon:[UIImage imageNamed:@"poi.png"]];
		
	[marker setCanShowCallout:YES];
		
	[marker setCalloutTitle:[_ad.storeMapInfo objectForKey:@"storeName"]];
	[marker setCalloutSubtitle:[_ad.storeMapInfo objectForKey:@"storeAddr"]];
	[marker setCalloutRightButtonImage:[UIImage imageNamed:@"rightBtn2.png"]];
	
	[_mapView addCustomObject:marker ID:markerID];
	
	
	[_mapView setCenterPoint:point];
	[self.viewMap addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
































