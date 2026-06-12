//
//  EAUtils.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 20.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Utility class providing helper methods for the game.
 * Includes random number generation, device detection, and asset naming.
 */
@interface EAUtils : NSObject

/**
 * Generates a random float between min and max values.
 * @param min Minimum value
 * @param max Maximum value
 * @return Random float in range
 */
+ (float)randomFloatWithMin:(CGFloat)min max:(CGFloat)max;

/// Checks if running on iPhone 5 (4-inch screen)
+ (BOOL)isIPhone5;

/// Checks if iOS version is less than 7.1
+ (BOOL)isLessThanIOS_7_1;

/// Checks if iOS version is 7.1 or greater
+ (BOOL)isGreaterThanOrEqualToIOS_7_1;

/// Returns appropriate background asset name based on device
+ (NSString *)assetName;

@end
