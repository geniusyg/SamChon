//
//  FriendPageViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 19..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "FriendPageViewController.h"
#import "AppDelegate.h"

@interface FriendPageViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation FriendPageViewController {
	AppDelegate *_ad;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *arr = [_ad.storeFri1 objectAtIndex:0];
	return [arr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FRIEND_CELL"];
	
	NSDictionary *tmp = [_ad.storeFri1 objectAtIndex:indexPath.row];
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [UIImage imageWithData:data];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 50, 50)];
//	imageView.image = img;
	imageView.tag = 131;
	
	UILabel *rname = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
//	rname.text = [tmp objectForKey:@"storeName"];
	rname.tag = 132;
	
	UILabel *raddr = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 20)];
//	raddr.text = [tmp objectForKey:@"storeAddr"];
	raddr.tag = 133;
	
	UILabel *rdate = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 50, 20)];
//	rdate.text = [tmp objectForKey:@"regDate"];
	rdate.textAlignment=NSTextAlignmentRight;
	rdate.tag = 134;
		
	[cell.contentView addSubview:imageView];
	[cell.contentView addSubview:rname];
	[cell.contentView addSubview:raddr];
	[cell.contentView addSubview:rdate];
	
	((UIImageView *)[cell.contentView viewWithTag:131]).image = img;
	((UILabel *)[cell.contentView viewWithTag:132]).text = [tmp objectForKey:@"storeName"];
	((UILabel *)[cell.contentView viewWithTag:133]).text = [tmp objectForKey:@"storeAddr"];
	((UILabel *)[cell.contentView viewWithTag:134]).text = [tmp objectForKey:@"regDate"];
	
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
- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end






























