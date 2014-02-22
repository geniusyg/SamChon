//
//  WriteViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "WriteSearchViewController.h"
#import "AFNetworking.h"

@interface WriteViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *menuTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldViews;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property UIImage *selectedImage;
@property (weak, nonatomic) IBOutlet UITextField *categoryText;

@end

@implementation WriteViewController {
	AppDelegate *_ad;
	int dy;
	BOOL _isChoosePic;
}

- (IBAction)openModal:(id)sender {
	if(0 == [self.searchTextField.text length]) {
		return;
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	WriteSearchViewController *wvc = [segue destinationViewController];
	wvc.keyword = self.searchTextField.text;
}

- (IBAction)upload:(id)sender {
	[[self firstResponderTextField] resignFirstResponder];
	
	NSLog(@"");
	if(0 == [self.searchTextField.text length] || 0 == [self.menuTextField.text length] || 0 == [self.commentTextField.text length] || _isChoosePic) {
		return;
	}
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	NSDictionary *parameters = @{@"id": _ad.uid, @"storeName":self.searchTextField.text, @"menuName":self.menuTextField.text, @"storeAddr":[_ad.writeSearch objectForKey:@"addr"], @"category":self.categoryText.text, @"lat":[_ad.writeSearch objectForKey:@"lat"], @"lng":[_ad.writeSearch objectForKey:@"lng"], @"userMemo":self.commentTextField.text};
	
	[manager POST:@"http://samchon.ygw3429.cloulu.com/write/writeBoardIos" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
	[self eraseForm];
}

- (IBAction)login:(id)sender {
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
		[self performSelector:@selector(goMain) withObject:nil afterDelay:1.0];
    } else {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
			[_ad sessionStateChanged:session state:state error:error];
			[self performSelector:@selector(goMain) withObject:nil afterDelay:2.0];
		}];
    }
}

- (void)eraseForm {
	[[self firstResponderTextField] resignFirstResponder];
	self.imageView.image = [UIImage imageNamed:@"photo.png"];
	self.searchTextField.text = @"";
	self.menuTextField.text = @"";
	self.commentTextField.text = @"";
	self.categoryText.text = @"";
	_ad.writeSearch = nil;
	_isChoosePic = YES;
	_ad.selectedCategory = @"9";
}

- (void)goMain {
	self.tabBarController.selectedIndex = 0;
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
	_isChoosePic = NO;
	_ad.isClear = NO;
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
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
	
	self.imageView.userInteractionEnabled = YES;
	
	_isChoosePic = YES;
	
	[self.imageView addGestureRecognizer:singleTap];
	
	self.categoryText.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		self.loginView.hidden = YES;
    } else {
        self.loginView.hidden = NO;
    }
	
	self.searchTextField.text = [_ad.writeSearch objectForKey:@"name"];
	
	if([_ad.selectedCategory isEqualToString:@"9"]) {
		self.categoryText.text = @"";
	} else {
		self.categoryText.text = [_ad.categories objectAtIndex:[_ad.selectedCategory integerValue]];
	}
	
	if(_ad.isClear) {
		[self eraseForm];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (UITextField *)firstResponderTextField {
	for(id child in self.textFieldViews.subviews){
		if([child isKindOfClass:[UITextField class]]){
			UITextField *textField = (UITextField *)child;
			if(textField.isFirstResponder) {
				return textField;
			}
		}
	}
	return nil;
}

- (void)keyboardWillShow:(NSNotification *)noti {
	
	UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
	int y = firstResponder.frame.origin.y + firstResponder.frame.size.height+5+380;
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

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end































