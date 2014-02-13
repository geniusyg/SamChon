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

@interface WriteViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationBarDelegate, UITextFieldDelegate, FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *menuTextField;
@property (weak, nonatomic) IBOutlet UIView *textFieldViews;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@end

@implementation WriteViewController {
	AppDelegate *_ad;
	int dy;
}

- (IBAction)upload:(id)sender {
	[[self firstResponderTextField] resignFirstResponder];
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

- (void)goMain {
	self.tabBarController.selectedIndex = 0;
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
	
	_ad = [[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		self.loginView.hidden = YES;
    } else {
        self.loginView.hidden = NO;
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































