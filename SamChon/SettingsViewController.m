//
//  SettingsViewController.m
//  SamChon
//
//  Created by SDT-1 on 2014. 1. 24..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController () <FBLoginViewDelegate>

@end

@implementation SettingsViewController {
	AppDelegate *_ad;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
	_ad.fbID = 0;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
	_ad.fbID = 1;
}

- (IBAction)puchOnOff:(id)sender {

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
	
	_ad = (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
