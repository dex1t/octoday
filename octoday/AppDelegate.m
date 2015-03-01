//
//  AppDelegate.m
//  octoday
//
//  Created by dex1t on 2015/02/16.
//  Copyright (c) 2015年 dex1t. All rights reserved.
//

#import "AppDelegate.h"
#import "GithubClient.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSMenu *menuBar;
@property (nonatomic) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupMenubar];
}

- (void)setupMenubar
{
    self.statusItem = [[NSStatusItem alloc] init];
    self.statusItem = [[NSStatusBar systemStatusBar]
        statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setImage:[NSImage imageNamed:@"menubarIcon"]];
    [self.statusItem setMenu:self.menuBar];
}

@end
