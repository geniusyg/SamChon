//
//  WriteSearchViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 13..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteSearchViewController.h"
#import "TMapView.h"
#import "AppDelegate.h"

#define TMAPID @"40150fac-a4cc-3225-b772-0fdf01f0075e"

@interface WriteSearchViewController () <UITableViewDataSource, UITableViewDelegate, TMapViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property TMapView *mapView;

@end

@implementation WriteSearchViewController {
	NSMutableArray *_data;
	AppDelegate *_ad;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.firstOtherButtonIndex == buttonIndex) {
		NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
		_ad.writeSearch = [_data objectAtIndex:indexPath.row];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"식당 검색" message:@"선택하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
	[alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCH_CELL"];
		
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SEARCH_CELL"];
	}
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
		UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 300, 20)];
		nameLabel.tag = 111;
		addrLabel.tag = 112;
		
//		[cell addSubview:nameLabel];
//		[cell addSubview:addrLabel];
//	}
//	
//	else {
//		UILabel *nameLabel = (UILabel *)[cell viewWithTag:111];
//		UILabel *addrLabel = (UILabel *)[cell viewWithTag:112];
	
		NSDictionary *tmp = [_data objectAtIndex:indexPath.row];
		nameLabel.text = [tmp objectForKey:@"name"];
		addrLabel.text = [tmp objectForKey:@"addr"];
	
	for(UIView *v in [cell subviews])
	{
		if([v isKindOfClass:[UILabel class]])
			[v removeFromSuperview];
	}
		[cell addSubview:nameLabel];
		[cell addSubview:addrLabel];

//	}
	return cell;
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
	
	_ad = [[UIApplication sharedApplication] delegate];
	
	_mapView = [[TMapView alloc] init];
	[_mapView setSKPMapApiKey:TMAPID];

	_mapView.delegate = self;
	
	TMapPathData *path = [[TMapPathData alloc] init];
	NSArray *result = [path requestFindTitlePOI:self.keyword];
	
	_data = [[NSMutableArray alloc] init];
	
	for(TMapPOIItem *item in result) {
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		TMapPoint *point = [item getPOIPoint];
		NSString *lat = [NSString stringWithFormat:@"%lf", [point getLatitude]];
		NSString *lng = [NSString stringWithFormat:@"%lf", [point getLongitude]];
		[tmp setValue:[item getPOIName] forKey:@"name"];
		[tmp setValue:[item getPOIAddress] forKey:@"addr"];
		[tmp setValue:lat forKey:@"lat"];
		[tmp setValue:lng forKey:@"lng"];		
		
		[_data addObject:tmp];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























