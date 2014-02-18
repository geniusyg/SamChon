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

@interface SearchViewController () <UISearchBarDelegate, TMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *tableView2;
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property TMapView *mapView;
@end

@implementation SearchViewController {
	AppDelegate *_ad;
	CLLocationManager *_lm;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *location = [locations lastObject];
    float _currentLat = location.coordinate.latitude;
    float  _currentLon = location.coordinate.longitude;
	
	TMapPoint * point =	[[TMapPoint alloc] initWithLon:_currentLon Lat:_currentLat];
	
	[_mapView setCenterPoint:point];
	
	TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
	[marker setTMapPoint:point];
	[marker setIcon:[UIImage imageNamed:@"point.png"]];
	
	[_mapView addCustomObject:marker ID:@"current_myMap"];
}

- (void)onCalloutRightbuttonClick:(TMapMarkerItem *)markerItem {
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCH_CELL2"];
	
	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[_mapView clearCustomObjects];
	
	NSString *keyword = searchBar.text;
	TMapPathData *path = [[TMapPathData alloc] init];
	NSArray *result = [path requestFindTitlePOI:keyword];
	
	int i=0;
	
	for(TMapPOIItem *item in result) {
		NSLog(@"Name %@ - Point %@", [item getPOIName], [item getPOIPoint]);
		
		NSString *markerID = [NSString stringWithFormat:@"marker_%d", i++];
		TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
		[marker setTMapPoint:[item getPOIPoint]];
		[marker setIcon:[UIImage imageNamed:@"point.png"]];
		
		[marker setCanShowCallout:YES];
		[marker setCalloutTitle:[item getPOIName]];
		[marker setCalloutSubtitle:[item getPOIAddress]];
		
		[_mapView addCustomObject:marker ID:markerID];
	}
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

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.mapView.hidden = YES;
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
	
	CGRect rect = CGRectMake(0, 0, 320, 317);
	
	_mapView = [[TMapView alloc] initWithFrame:rect];
	[_mapView setSKPMapApiKey:TMAPID];
	
	_mapView.delegate = self;
	
	[self.viewMap addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























