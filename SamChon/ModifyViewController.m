//
//  ModifyViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 2. 18..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "ModifyViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "WriteSearchViewController.h"

@interface ModifyViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

@property (weak, nonatomic) IBOutlet UITextField *menuLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchLabel;
@property (weak, nonatomic) IBOutlet UITextField *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property UIImage *selectedImage;

@end

@implementation ModifyViewController {
	AppDelegate *_ad;
	int dy;
	NSDictionary *tmp;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WriteSearchViewController *wvc = (WriteSearchViewController *)segue.destinationViewController;
	wvc.keyword = self.searchLabel.text;
}

- (UITextField *)firstResponderTextField {
	for(id child in self.textFieldView.subviews){
		if([child isKindOfClass:[UITextField class]]){
			UITextField *textField = (UITextField *)child;
			if(textField.isFirstResponder) {
				return textField;
			}
		}
	}
	return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([actionSheet cancelButtonIndex] == buttonIndex) {
		return;
	}
	
	UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
	ipc.delegate = self;
	
	if([actionSheet destructiveButtonIndex] == buttonIndex) {
		[ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
		
	} else if([actionSheet firstOtherButtonIndex] == buttonIndex) {
		[ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
	}
	
	[ipc setAllowsEditing:YES];
	[self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	self.selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
	self.imageView.image = self.selectedImage;
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)modify:(id)sender {
	[[self firstResponderTextField] resignFirstResponder];
	
	if(0 == [self.addrLabel.text length] || 0 == [self.searchLabel.text length] || 0 == [self.menuLabel.text length] || 0 == [self.commentLabel.text length]) {
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id": _ad.uid, @"storeName":self.searchLabel.text, @"menuName":self.menuLabel.text, @"storeAddr":self.addrLabel.text, @"category":@"0", @"lat":[_ad.writeSearch objectForKey:@"lat"], @"lng":[_ad.writeSearch objectForKey:@"lng"], @"userMemo":self.commentLabel.text, @"category":_ad.selectedCategory};
	[manager POST:@"http://samchon.ygw3429.cloulu.com/write/modify" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
		NSData *imgData = UIImageJPEGRepresentation(self.selectedImage, 0.5);
		NSDate *date = [NSDate date];
		NSString *fileName = [NSString stringWithFormat:@"%@_%@",_ad.uid,date];
		[formData appendPartWithFileData:imgData name:@"imgUrl" fileName:fileName mimeType:@"image/jpeg"];
	} success:^(AFHTTPRequestOperation *operation, id responseObject) {
		NSLog(@"Success: %@", responseObject);
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
	}];
	
	[_ad getMyBoardList];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeModal:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	self.menuLabel.text = [tmp objectForKey:@"menuName"];
	self.commentLabel.text = [tmp objectForKey:@"userMemo"];
	
	if(nil == _ad.writeSearch) {
		self.searchLabel.text = [tmp objectForKey:@"storeName"];
		self.addrLabel.text = [tmp objectForKey:@"storeAddr"];
		self.categoryLabel.text = [_ad.categories objectAtIndex:[[tmp objectForKey:@"category"] integerValue]];
	} else {
		self.searchLabel.text = [_ad.writeSearch objectForKey:@"name"];
		self.addrLabel.text = [_ad.writeSearch objectForKey:@"addr"];
		self.categoryLabel.text = [_ad.categories objectAtIndex:[_ad.selectedCategory integerValue]];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	
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
	
	_ad.writeSearch = nil;
	
	tmp = [_ad.myBoardList objectAtIndex:self.index];
	
	NSString *path = [NSString stringWithFormat:@"%@",[tmp objectForKey:@"foodPic"]];
	NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSData *data = [NSData dataWithContentsOfURL:url];
	self.selectedImage = [UIImage imageWithData:data];
	self.imageView.image = self.selectedImage;
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
	
	self.imageView.userInteractionEnabled = YES;
	
	[self.imageView addGestureRecognizer:singleTap];
}

- (void)keyboardWillShow:(NSNotification *)noti {
	
	UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
	int y = firstResponder.frame.origin.y + firstResponder.frame.size.height+5+350;
	int viewHeight = self.view.frame.size.height;
	
	NSDictionary *userInfo = [noti userInfo];
	CGRect rect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	int keyboardHeight = (int)rect.size.height;
	
	float ani = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
	
	if(keyboardHeight > (viewHeight - y)){
		[UIView animateWithDuration:ani animations:^{
			dy = keyboardHeight - (viewHeight -y);
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y-dy);
		}];
	} else {
		dy = 0;
	}
	
}

- (void)keyboardWillHide:(NSNotification *)noti {
	
	if(dy>0) {
		float ani = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
		[UIView animateWithDuration:ani animations:^{
			self.view.center = CGPointMake(self.view.center.x, self.view.center.y + dy);
		}];
	}
}

- (void)imageTapped {
	UIActionSheet *as;
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		as = [[UIActionSheet alloc] initWithTitle:@"선택하세요" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:@"사진찍기" otherButtonTitles:@"사진첩에서 고르기", nil];
	} else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
		as = [[UIActionSheet alloc] initWithTitle:@"선택하세요" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"사진첩에서 고르기", nil];
	}
	
	UIView *keyView = [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0];
	[as showInView:keyView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



































