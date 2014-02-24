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

@interface WriteSearchViewController () <UITableViewDataSource, UITableViewDelegate, TMapViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property UIActionSheet *actionSheet;
@property UIPickerView *pickerView;
@property UIToolbar *toolbar;
@property TMapView *mapView;

@end

@implementation WriteSearchViewController {
	NSMutableArray *_data;
	AppDelegate *_ad;
	UIActionSheet *sheet;
	NSInteger _category;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [_ad.categories objectAtIndex:row];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([actionSheet cancelButtonIndex] == buttonIndex) {
		return;
	}
	
	UIPickerView *pick = [[UIPickerView alloc] init];
	pick.delegate = self;
	

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [_ad.categories count];
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"식당 검색" message:@"선택하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//	[alert show];
//}
//
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//	if(alertView.firstOtherButtonIndex == buttonIndex) {
//		NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
//		_ad.writeSearch = [_data objectAtIndex:indexPath.row];
//		[self dismissViewControllerAnimated:YES completion:nil];
//	}
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_data count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	
	self.actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 320, 55)];
	self.pickerView.showsSelectionIndicator = YES;
	self.pickerView.dataSource = self;
	self.pickerView.delegate = self;
	[self.actionSheet addSubview:self.pickerView];
	
	self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	self.toolbar.barStyle = UIBarStyleDefault;
	[self.toolbar setTintColor:[UIColor blackColor]];
	[self.pickerView sizeToFit];
	
	UIBarButtonItem *flexSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelActionSheet)];
	UIBarButtonItem *donBtnItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneActionSheet)];
	
	[self.toolbar setItems:@[flexSpaceItem,cancelBtnItem,donBtnItem]];
	[self.actionSheet addSubview:self.toolbar];
	
	[self.actionSheet showInView:self.view];
	[self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void)cancelActionSheet {
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)doneActionSheet {
	_ad.selectedCategory = [NSString stringWithFormat:@"%ld", [self.pickerView selectedRowInComponent:0]];
	
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
	_ad.writeSearch = [_data objectAtIndex:indexPath.row];
	
	[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCH_CELL"];
		
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SEARCH_CELL"];

		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 300, 20)];
		UILabel *addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 300, 20)];
		nameLabel.tag = 113;
		addrLabel.tag = 114;
		
		[cell.contentView addSubview:nameLabel];
		[cell.contentView addSubview:addrLabel];
	
		NSDictionary *tmp = [_data objectAtIndex:indexPath.row];
	
	((UILabel *)[cell.contentView viewWithTag:113]).text = [tmp objectForKey:@"name"];
	((UILabel *)[cell.contentView viewWithTag:114]).text = [tmp objectForKey:@"addr"];
	
//	for(UIView *v in [cell.contentView subviews])
//	{
//		if([v isKindOfClass:[UILabel class]])
//			[v removeFromSuperview];
//	}
//		[cell.contentView addSubview:nameLabel2];
//		[cell.contentView addSubview:addrLabel2];

	return cell;
}

- (IBAction)closeModal:(id)sender {
	_ad.isClear = NO;
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
	
	_mapView = [[TMapView alloc] init];
	[_mapView setSKPMapApiKey:TMAPID];

	_mapView.delegate = self;
	
	TMapPathData *path = [[TMapPathData alloc] init];
	
	TMapPoint *currentPoint = [[TMapPoint alloc] initWithLon:[_ad.currentLng doubleValue] Lat:[_ad.currentLat doubleValue]];
	
	NSArray *result = [path requestFindAroundKeywordPOI:currentPoint keywordName:self.keyword radius:33 resultCount:1000];
//	NSArray *result = [path requestFindTitlePOI:self.keyword];
	
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	_ad.isClear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_ad.isClear = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

























