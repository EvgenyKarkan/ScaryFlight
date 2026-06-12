//
//  EAScoresStoreManager.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScoresStoreManager.h"

static  NSString * kTopScore= @"kTopScore";

/// Injected backing store; nil means standard user defaults
static NSUserDefaults *_userDefaults = nil;


@implementation EAScoresStoreManager;

+ (NSUserDefaults *)userDefaults
{
    return _userDefaults ?: [NSUserDefaults standardUserDefaults];
}

+ (void)setUserDefaults:(NSUserDefaults *)userDefaults
{
    _userDefaults = userDefaults;
}

/**
 * Stores the top score in NSUserDefaults for persistence between sessions.
 * NSUserDefaults persists asynchronously on its own; forcing a synchronous
 * flush here would block the main thread during the game over transition.
 */
+ (void)setTopScore:(NSUInteger)topScore
{
    NSString *valueToSave = [NSString stringWithFormat:@"%lu", (unsigned long)topScore];

    [[self userDefaults] setObject:valueToSave forKey:kTopScore];
}

+ (NSUInteger)getTopScore
{
    // NSUserDefaults key for stored top score
    NSString *savedValue = [[self userDefaults] stringForKey:kTopScore];

    return (NSUInteger)[savedValue integerValue];
}

@end
