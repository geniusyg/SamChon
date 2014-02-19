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
	return 70;
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
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
//	imageView.image = img;
	imageView.tag = 118;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
//	rname.text = [tmp objectForKey:@"friName"];
	rname.tag = 119;
	
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	
	((UIImageView *)[cell.contentView viewWithTag:118]).image = img;
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
	
	[self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end












































