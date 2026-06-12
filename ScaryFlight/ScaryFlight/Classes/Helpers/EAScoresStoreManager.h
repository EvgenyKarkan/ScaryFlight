//
//  EAScoresStoreManager.h
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Persistent score storage manager using NSUserDefaults.
 * Handles saving and retrieving the top score between game sessions.
 */
@interface EAScoresStoreManager : NSObject

/**
 * Saves the top score to persistent storage.
 * @param topScore The score value to save
 */
+ (void)setTopScore:(NSUInteger)topScore;

/// Retrieves the saved top score (0 if none saved)
+ (NSUInteger)getTopScore;

/**
 * Backing store used for persistence.
 * Defaults to [NSUserDefaults standardUserDefaults] when nothing is injected.
 */
+ (NSUserDefaults *)userDefaults;

/**
 * Injects a custom backing store, e.g. an isolated suite in unit tests.
 * Pass nil to restore the standard user defaults.
 */
+ (void)setUserDefaults:(NSUserDefaults *)userDefaults;

@end
