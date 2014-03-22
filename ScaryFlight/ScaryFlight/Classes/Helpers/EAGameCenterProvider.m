//
//  EAGameCenterProvider.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 18.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAGameCenterProvider.h"
#import "EAAppDelegate.h"

static NSString * const kEALeaderboardID = @"BestScoreID";

@interface EAGameCenterProvider () <GKGameCenterControllerDelegate>

@property (nonatomic, assign) BOOL           gameCenterAvailable;
@property (nonatomic, strong) EAAppDelegate *appDelegate;

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
    NSException *exception = [[NSException alloc] initWithName:@"Don't use +new method"
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
        self.appDelegate = (EAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
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
        [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *gameCenterLoginViewController, NSError *error) {
            if (gameCenterLoginViewController != nil) {
                [self.appDelegate.gameViewController presentViewController:gameCenterLoginViewController
                                                                  animated:YES
                                                                completion:nil];
            }
        };
    }
    else {
        NSLog(@"Already authenticated!");
    }
}

- (void)reportScore:(NSUInteger)score
{
    if ([GKLocalPlayer localPlayer].isAuthenticated) {
        GKScore *scoreToReport = [[GKScore alloc] initWithLeaderboardIdentifier:kEALeaderboardID];
        scoreToReport.value = (int64_t)score;
        
        [GKScore reportScores:@[scoreToReport] withCompletionHandler: ^(NSError *error) {
            NSParameterAssert(error == nil);
            if (error != nil) {
                NSLog(@"Error occured: %@", [error localizedDescription]);
            }
        }];
    }
    else {
        NSLog(@"Score is not reported: player not authenticated");
    }
}

- (void)showLeaderboard
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardIdentifier = kEALeaderboardID;
        
        [self.appDelegate.gameViewController presentViewController:gameCenterController
                                                          animated:YES
                                                        completion:nil];
    }
}

#pragma mark - GKGameCenterControllerDelegate

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self.appDelegate.gameViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
