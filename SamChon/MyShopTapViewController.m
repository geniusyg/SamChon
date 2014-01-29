//
//  MyShopTapViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 27..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopTapViewController.h"
#import "MyShopTableViewController.h"

@interface MyShopTapViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation MyShopTapViewController {
	NSMutableArray *_data;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	NSIndexPath *indexPath = [self.table indexPathForSelectedRow];
	MyShopTableViewController *mtvc = segue.destinationViewController;
	mtvc.count = indexPath.row;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[_data removeObjectAtIndex:indexPath.row];
	
	NSArray *rows = [NSArray arrayWithObject:indexPath];
	
	[tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SHOP_CELL"];
	
	tableView.separatorColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	cell.textLabel.text = [_data objectAtIndex:indexPath.row];
	
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
	
	_data = [NSMutableArray arrayWithObjects:@"AA", @"BB", @"CC", @"DD", @"EE", @"FF", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end





























