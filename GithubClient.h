//
//  GithubClient.h
//  octoday
//
//  Created by dex1t on 2015/02/22.
//  Copyright (c) 2015年 dex1t. All rights reserved.
//

#import "Octokit.h"

@interface GithubClient : NSObject

+ (instancetype)sharedClient;
- (void)savePreferences:(NSString *)gheHostname userName:(NSString *)userName token:(NSString *)token;
- (OCTClient *)client;
- (NSString *)savedGheHostname;
- (NSString *)savedUserName;
- (NSString *)savedToken;
- (OCTServer *)usingGithubServer;

@end
