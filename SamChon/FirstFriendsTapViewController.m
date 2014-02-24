//
//  FirstFriendsTapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "FirstFriendsTapViewController.h"
#import "AppDelegate.h"
#import "FriendPageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface FirstFriendsTapViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FirstFriendsTapViewController {
	AppDelegate *_ad;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	FriendPageViewController *fpvc = (FriendPageViewController *)segue.destinationViewController;
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:indexPath.row];
	fpvc.friId = [tmp objectForKey:@"friId"];
	fpvc.friName = [tmp objectForKey:@"friName"];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"차단";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_ad.storeFri1 count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
//	[_ad.storeFri1 removeObjectAtIndex:indexPath.row];
	
	NSArray *rows = [NSArray arrayWithObject:indexPath];
	[tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRIENDS_CELL"];
	
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:indexPath.row];
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"friPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 49, 49)];
	imageView.layer.cornerRadius = 25.0f;
	imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
	
	imageView.layer.shouldRasterize = YES;
	imageView.clipsToBounds = YES;
//	imageView.image = img;
	imageView.tag = 118;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(68, 24, 200, 20)];
	rname.font = [rname.font fontWithSize:13];
	rname.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
	
//	rname.text = [tmp objectForKey:@"friName"];
	rname.tag = 119;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	
	[((UIImageView *)[cell.contentView viewWithTag:118]) setImageWithURL:url placeholderImage:[UIImage imageNamed:@"question-75.png"]];
	((UILabel *)[cell.contentView viewWithTag:119]).text = [tmp objectForKey:@"friName"];
	
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	_ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:@"getFriendsList" object:nil];
	
	[_ad getMyFriends];
	
	[self.table reloadData];
	}
}

- (void)refreshTable {

	[self.table reloadData];
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












































