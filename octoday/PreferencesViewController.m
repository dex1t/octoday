//
//  PreferencesViewController.m
//  octoday
//
//  Created by dex1t on 2015/02/23.
//  Copyright (c) 2015年 dex1t. All rights reserved.
//

#import "PreferencesViewController.h"
#import "GithubClient.h"

@interface PreferencesViewController ()

@property (weak) IBOutlet NSButton *useGithubDotComButton;
@property (weak) IBOutlet NSTextField *hostnameField;
@property (weak) IBOutlet NSTextField *userNameField;
@property (weak) IBOutlet NSTextField *tokenField;

- (IBAction)useGithubDotComButtonAction:(NSButton *)sender;

@end

@implementation PreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSavedPreferences];
}

- (void)viewDidDisappear
{
    [[GithubClient sharedClient] savePreferences:self.hostnameField.stringValue
                                        userName:self.userNameField.stringValue
                                           token:self.tokenField.stringValue];
}

- (IBAction)useGithubDotComButtonAction:(NSButton *)sender
{
    if ([sender state]) {
        self.hostnameField.enabled = NO;
        self.hostnameField.stringValue = @"";
    } else {
        self.hostnameField.enabled = YES;
        [self.hostnameField becomeFirstResponder];
    }
}

#pragma mark - Private

- (void)loadSavedPreferences
{
    GithubClient *client = [GithubClient sharedClient];
    NSString *gheHostname = [client savedGheHostname];

    if (gheHostname && [gheHostname isNotEqualTo:@""]) {
        [self.useGithubDotComButton setState:0];
        [self.hostnameField setStringValue:gheHostname];
        self.hostnameField.enabled = YES;
    }
    [self.userNameField setStringValue:[client savedUserName]];
    [self.tokenField setStringValue:[client savedToken]];
}

@end
