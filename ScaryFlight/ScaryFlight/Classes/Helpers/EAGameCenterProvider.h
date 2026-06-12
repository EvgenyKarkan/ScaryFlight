//
//  EAGameCenterProvider.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 18.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Game Center integration provider for score reporting and leaderboards.
 * Singleton class that handles authentication, score submission,
 * and leaderboard display via GKGameCenterViewController.
 */
@interface EAGameCenterProvider : NSObject 

/// Indicates if the local player is currently authenticated
@property (nonatomic, assign) BOOL userAuthenticated;

/// Shared singleton instance
+ (EAGameCenterProvider *)sharedInstance;

/// Initiates Game Center authentication
- (void)authenticateLocalUser;

/**
 * Reports a score to Game Center leaderboard.
 * @param score The score value to report
 */
- (void)reportScore:(NSUInteger)score;

/// Displays the Game Center leaderboard UI
- (void)showLeaderboard;

@end
