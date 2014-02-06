//
//  WriteViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "WriteViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface WriteViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *menuTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldViews;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@end

@implementation WriteViewController {
	int dy;
	AppDelegate *_ad;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
	self.loginView.hidden = YES;
	_ad.fbID = 0;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
	self.loginView.hidden = YES;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
	self.loginView.hidden = YES;
	
}

- (IBAction)upload:(id)sender {
	[[self firstResponderTextField] resignFirstResponder];
}

- (IBAction)cancelWrite:(id)sender {
	[[self firstResponderTextField] resignFirstResponder];
	self.imageView.image = [UIImage imageNamed:@"camera_identification-128.png"];
	self.searchTextField.text = @"";
	self.menuTextField.text = @"";
	self.commentTextField.text = @"";
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
	UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
	self.imageView.image = img;
	[picker dismissViewControllerAnimated:YES completion:nil];
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
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	_ad = (AppDelegate*)[[UIApplication sharedApplication]delegate];
	if(0 == _ad.fbID) {
		self.loginView.hidden = YES;
	}
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
	
	self.imageView.userInteractionEnabled = YES;
	
	[self.imageView addGestureRecognizer:singleTap];
	
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































