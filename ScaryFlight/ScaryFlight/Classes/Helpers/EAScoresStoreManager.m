//
//  EAScoresStoreManager.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScoresStoreManager.h"

static  NSString * kTopScore= @"kTopScore";


@implementation EAScoresStoreManager;

/**
 * Stores the top score in NSUserDefaults for persistence between sessions.
 * Synchronously saves to ensure data is written immediately.
 */
+ (void)setTopScore:(NSUInteger)topScore
{
    NSString *valueToSave = [NSString stringWithFormat:@"%lu", (unsigned long)topScore];
    
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:kTopScore];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSUInteger)getTopScore
{
    // NSUserDefaults key for stored top score
    NSString *savedValue = [[NSUserDefaults standardUserDefaults] stringForKey:kTopScore];
    
    return (NSUInteger)[savedValue integerValue];
}

@end
