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
@property (weak) IBOutlet NSButton *testConnectionButton;
@property (weak) IBOutlet NSProgressIndicator *indicator;
@property (weak) IBOutlet NSTextField *resultLabel;

- (IBAction)useGithubDotComButtonAction:(NSButton *)sender;
- (IBAction)testConnectionButtonAction:(NSButton *)sender;

@end

@implementation PreferencesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSavedPreferences];
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
    [self savePreferences];
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

- (IBAction)testConnectionButtonAction:(NSButton *)sender
{
    [self savePreferences];

    self.testConnectionButton.enabled = NO;
    self.resultLabel.hidden = YES;
    [self.resultLabel setStringValue:@""];
    [self.indicator startAnimation:nil];
    self.indicator.hidden = NO;

    [[GithubClient sharedClient] authenticate]; // require re-authenticate
    RACSignal *request = [[[[GithubClient sharedClient] client] fetchUserRepositories] finally:^{
        self.testConnectionButton.enabled = YES;
        self.indicator.hidden = YES;
        self.resultLabel.hidden = NO;
    }];

    [[request collect] subscribeNext:^(NSArray *repositories) {
        [self.resultLabel setTextColor:[NSColor colorWithCalibratedRed:0.251 green:0.502 blue:0.000 alpha:1.000]];
        [self.resultLabel setStringValue:@"Success"];
    } error:^(NSError *error) {
        [self.resultLabel setTextColor:[NSColor redColor]];
        [self.resultLabel setStringValue:@"Failed"];
    }];
}

#pragma mark - Private

- (void)savePreferences
{
    [[GithubClient sharedClient] savePreferences:self.hostnameField.stringValue
                                        userName:self.userNameField.stringValue
                                           token:self.tokenField.stringValue];
}

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
