//
//  GithubClient.m
//  octoday
//
//  Created by dex1t on 2015/02/22.
//  Copyright (c) 2015年 dex1t. All rights reserved.
//

#import "GithubClient.h"
#import "UICKeyChainStore.h"

@interface GithubClient ()

@property (nonatomic) OCTClient *authenticatedClient;
@property (nonatomic) UICKeyChainStore *keychain;

@end

@implementation GithubClient

static GithubClient *_sharedInstance = nil;
NSString *const KEYCHAIN_SERVICE_KEY = @"org.degoo.octoday";
NSString *const GHE_HOSTNAME_KEY = @"gheHostname";
NSString *const USER_NAME_KEY = @"userName";
NSString *const TOKEN_KEY = @"secretToken";

+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [GithubClient new];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.authenticatedClient = nil;
        self.keychain = [UICKeyChainStore keyChainStoreWithService:KEYCHAIN_SERVICE_KEY];
    }
    return self;
}

- (void)savePreferences:(NSString *)gheHostname userName:(NSString *)userName token:(NSString *)token
{
    self.keychain[GHE_HOSTNAME_KEY] = gheHostname;
    self.keychain[USER_NAME_KEY] = userName;
    self.keychain[TOKEN_KEY] = token;
}

- (NSString *)savedGheHostname
{
    return self.keychain[GHE_HOSTNAME_KEY];
}

- (NSString *)savedUserName
{
    return self.keychain[USER_NAME_KEY];
}

- (NSString *)savedToken
{
    return self.keychain[TOKEN_KEY];
}

- (OCTServer *)usingGithubServer
{
    NSString *gheHostname = [self savedGheHostname];
    if (gheHostname && [gheHostname isNotEqualTo:@""]) {
        return [OCTServer serverWithBaseURL:[NSURL URLWithString:gheHostname]];
    }
    return [OCTServer dotComServer];
}

- (void)authenticate
{
    OCTUser *user = [OCTUser userWithRawLogin:[self savedUserName]
                                       server:[self usingGithubServer]];
    self.authenticatedClient = [OCTClient authenticatedClientWithUser:user
                                                                token:[self savedToken]];
}

- (OCTClient *)client
{
    if (!self.authenticatedClient) {
        [self authenticate];
    }
    return self.authenticatedClient;
}

@end
