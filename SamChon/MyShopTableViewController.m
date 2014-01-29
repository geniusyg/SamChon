//
//  MyShopTableViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 29..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "MyShopTableViewController.h"

@interface MyShopTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *table;
@property UITextField *replyTextField;

@end

@implementation MyShopTableViewController {
	NSMutableArray *_images;
	NSMutableArray *_replys[9];
	UIScrollView *_sv;
	NSInteger _loadedPageCount;
}
- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)write:(id)sender {
	[self writeReply];
	[self.replyTextField resignFirstResponder];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.table.separatorColor = [UIColor clearColor];
	
	_loadedPageCount = self.count;
	
	_images = [[NSMutableArray alloc] init];
	
	_replys[0] = [NSMutableArray arrayWithObjects:@"AA",@"BB",@"CC",@"DD",@"EE", nil];
	_replys[1] = [NSMutableArray arrayWithObjects:@"FF",@"GG",@"HH",@"II",@"JJ", nil];
	_replys[2] = [NSMutableArray arrayWithObjects:@"KK",@"LL",@"MM",@"NN",@"EE", nil];
	_replys[3] = [NSMutableArray arrayWithObjects:@"OO",@"PP",@"QQ",@"RR",@"EE", nil];
	_replys[4] = [NSMutableArray arrayWithObjects:@"SS",@"TT",@"UU",@"VV",@"WW", nil];
	_replys[5] = [NSMutableArray arrayWithObjects:@"XX",@"YY",@"ZZ",@"AA",@"BB", nil];
	_replys[6] = [NSMutableArray arrayWithObjects:@"CC",@"BB",@"AA",@"DD",@"EE", nil];
	_replys[7] = [NSMutableArray arrayWithObjects:@"HH",@"GG",@"FF",@"GG",@"HH", nil];
	_replys[8] = [NSMutableArray arrayWithObjects:@"MM",@"NN",@"OO",@"TT",@"QQ", nil];
	
	for(int i=0; i<9; i++) {
		NSString *tmp = [NSString stringWithFormat:@"img%d", i];
		UIImage *img = [UIImage imageNamed:[tmp stringByAppendingString:@".jpg"]];
		[_images addObject:img];
	}
	
	_sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
	float w = _sv.bounds.size.width;
	float h	= _sv.bounds.size.height;
	_sv.delegate = self;
	_sv.pagingEnabled = YES;
	_sv.contentSize = CGSizeMake(w*9, h);
	[_sv setContentOffset:CGPointMake(self.count*280 - 10, 0)];
	
	[self loadContentsPage:_loadedPageCount-1];
	[self loadContentsPage:_loadedPageCount];
	[self loadContentsPage:_loadedPageCount+1];
	
	self.replyTextField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, 250, 30)];
	self.replyTextField.delegate = self;
	[self.replyTextField resignFirstResponder];
	self.replyTextField.placeholder = @"식당에 대한 댓글을 입력해 주세요!";
	self.replyTextField.backgroundColor = [UIColor whiteColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)writeReply {
	NSString *reply = self.replyTextField.text;
	if([reply length] > 0) {
	NSLog(@"%@", reply);
	self.replyTextField.text = @"";
	} else {
		return;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0:
			return 73;
		case 1:
			return 250;
		case 2:
			return 50;
		case 3:
			return 50;
			
		default:
			break;
	}
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
		case 0:
			return 1;
		case 1:
			return 1;
		case 2:
			return 1;
		case 3:
			return [_replys[0] count];
	}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:@"TITLE_CELL"];
			break;
		case 1: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"SCROLL_CELL"];
			
//			CGFloat scrollWidth = 20.f;
//			for (int i = 0; i<9; i++) {
//				UIImageView *theView = [[UIImageView alloc] initWithFrame:
//										CGRectMake(scrollWidth, 0, 260, 250)];
//				theView.userInteractionEnabled = YES;
//				theView.image = [_images objectAtIndex:i];
//				[_sv addSubview:theView];
//				scrollWidth += 280;
//			}
//			_sv.contentSize = CGSizeMake(scrollWidth, 250);
			
			[cell addSubview:_sv];
			break;
		}
		case 2:
			cell = [tableView dequeueReusableCellWithIdentifier:@"WRITE_CELL"];
			[cell addSubview:self.replyTextField];
			break;
		case 3: {
			cell = [tableView dequeueReusableCellWithIdentifier:@"REPLY_CELL"];
			cell.textLabel.text = [_replys[0] objectAtIndex:indexPath.row];
		}
			break;
		default:
			break;
	}
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)loadContentsPage:(int)pageNo {
    if(pageNo < 0 || pageNo < _loadedPageCount || pageNo >= 9)
        return;
    
    float w = _sv.frame.size.width;
    float h =_sv.frame.size.height;
    
    NSString *fileName = [NSString stringWithFormat:@"img%d",pageNo];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    UIImageView *iv = [[UIImageView alloc] initWithImage:image];
    
    iv.frame = CGRectMake(w*pageNo, 0, w,h);
    [_sv addSubview:iv];
    _loadedPageCount++;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float w = scrollView.frame.size.width;
    float offsetX = scrollView.contentOffset.x;
    int pageNo = floor(offsetX/w);
	//    pageControl.currentPage = pageNo;
    
    [self loadContentsPage:pageNo-1];
    [self loadContentsPage:pageNo];
    [self loadContentsPage:pageNo+1];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end






























