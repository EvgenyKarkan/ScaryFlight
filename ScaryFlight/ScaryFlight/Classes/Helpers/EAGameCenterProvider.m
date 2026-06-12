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

- (instancetype)init
{
    if ((self = [super init])) {
        _gameCenterAvailable = [self isGameCenterAvailable];
        _appDelegate         = (EAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
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

/**
 * Checks if Game Center is available on this device.
 * Verifies iOS version >= 4.1 and GKLocalPlayer class exists.
 */
- (BOOL)isGameCenterAvailable
{
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

/**
 * Called when Game Center authentication state changes.
 * Updates userAuthenticated property for score reporting logic.
 */
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

/**
 * Authenticates the local player with Game Center.
 * Presents login UI if authentication is needed.
 * Called automatically at app launch.
 */
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

/**
 * Reports score to Game Center leaderboard asynchronously.
 * Only reports if player is authenticated.
 */
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

/**
 * Presents Game Center leaderboard view controller.
 * Shows "BestScoreID" leaderboard to authenticated players.
 */
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

/**
 * Dismisses the Game Center view controller when user finishes.
 * Required delegate method for proper dismissal handling.
 */
- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self.appDelegate.gameViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
