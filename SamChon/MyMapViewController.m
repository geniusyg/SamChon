//
//  MyMapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyMapViewController.h"
#import "TMapView.h"
#import "AppDelegate.h"
#import "MyShopTableViewController.h"

#define TMAPID @"40150fac-a4cc-3225-b772-0fdf01f0075e"

@interface MyMapViewController () <TMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodImage;
@property (weak, nonatomic) IBOutlet UIView *viewMap;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property TMapView *mapView;

@end

@implementation MyMapViewController {
	CLLocationManager *_lm;
	AppDelegate *_ad;
	NSInteger _index;
}
- (IBAction)closeDetail:(id)sender {
	self.detailView.hidden = YES;
}

- (void)onCalloutRightbuttonClick:(TMapMarkerItem *)markerItem {
	NSString *ids = [markerItem getID];
	NSArray *arr = [ids componentsSeparatedByString:@"_"];
	
	NSDictionary *tmp = [_ad.myBoardList objectAtIndex:[[arr objectAtIndex:1] intValue]];
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	UIImage *imgWeb = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
	
	self.foodImage.image = imgWeb;
	
	self.nameLabel.text = [tmp objectForKey:@"storeName"];
	self.addrLabel.text = [tmp objectForKey:@"storeAddr"];
	
	_index = [[arr objectAtIndex:1] integerValue];
	self.detailView.hidden = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	MyShopTableViewController *mtvc = segue.destinationViewController;
	mtvc.loadedPage = _index;
}

- (IBAction)close:(id)sender {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
	_mapView = [[TMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 408)];
	[_mapView setSKPMapApiKey:TMAPID];
	
	_mapView.delegate = self;
	
	_lm = [[CLLocationManager alloc] init];
	
	_lm.delegate = self;
	_lm.desiredAccuracy = kCLLocationAccuracyBest;
	_lm.distanceFilter = 1000.0f;
	[_lm startUpdatingLocation];
	
	for(int i=0; i<[_ad.myBoardList count]; i++) {
		NSDictionary *tmp = [_ad.myBoardList objectAtIndex:i];
		
		NSString *markerID = [NSString stringWithFormat:@"marker2_%d", i];
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
	
	[self.viewMap addSubview:_mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end































