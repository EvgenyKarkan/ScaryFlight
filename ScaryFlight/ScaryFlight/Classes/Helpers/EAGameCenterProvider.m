//
//  EAGameCenterProvider.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 18.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAGameCenterProvider.h"
#import "EAAppDelegate.h"

@interface EAGameCenterProvider ()

@property (nonatomic, assign) BOOL gameCenterAvailable;
@property (nonatomic, assign) BOOL userAuthenticated;

@end


@implementation EAGameCenterProvider;

#pragma mark - Singleton stuff

static id _sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EAGameCenterProvider alloc] init];
    });
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = nil;
        _sharedInstance = [super allocWithZone:zone];
    });
    
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)new
{
    NSException *exception = [[NSException alloc] initWithName:@"Do not use +new method"
                                                        reason:@"Use +sharedInstance instead"
                                                      userInfo:nil];
    [exception raise];
    
    return nil;
}

#pragma mark - Overriden init with subscribing to GKPlayerAuthenticationDidChangeNotificationName notification

- (id)init
{
    if ((self = [super init])) {
        self.gameCenterAvailable = [self isGameCenterAvailable];
        if (self.gameCenterAvailable) {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter addObserver:self
                                   selector:@selector(authenticationChanged)
                                       name:GKPlayerAuthenticationDidChangeNotificationName
                                     object:nil];
        }
    }
    return self;
}

#pragma mark - Private API

- (BOOL)isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (void)authenticationChanged
{
    if ([GKLocalPlayer localPlayer].isAuthenticated && !self.userAuthenticated) {
        NSLog(@"Authentication changed: player authenticated.");
        self.userAuthenticated = YES;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && self.userAuthenticated) {
        NSLog(@"Authentication changed: player not authenticated");
        self.userAuthenticated = NO;
    }
}

#pragma mark - Public API

- (void)authenticateLocalUser
{
    if (!self.gameCenterAvailable) {
        return;
    }
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        EAAppDelegate *appDelegate = (EAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *gameCenterLoginViewController, NSError *error) {
            if (gameCenterLoginViewController != nil) {
                [appDelegate.gameViewController presentViewController:gameCenterLoginViewController
                                                             animated:YES
                                                           completion:nil];
            }
        };
    }
    else {
        NSLog(@"Already authenticated!");
    }
}

@end
