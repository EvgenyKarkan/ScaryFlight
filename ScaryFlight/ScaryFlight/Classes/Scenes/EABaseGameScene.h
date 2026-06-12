//
//  EABaseGameScene.h
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/15/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAHero.h"
#import "EAObstacle.h"

/**
 * Base game scene providing core FlappyBird-style gameplay mechanics.
 * Manages hero sprite, obstacle generation, scoring, physics world, and game state.
 * Subclasses must override the following methods to provide themed assets:
 * - heroImageStateOne, heroImageStateTwo: Hero animation frames
 * - topObstacleImage, bottomObstacleImage: Obstacle sprite names
 * - backgroundImageName: Background image name
 */
@interface EABaseGameScene : SKScene

/// The player's hero sprite that flies through obstacles
@property (nonatomic, strong) EAHero *hero;

/**
 * Adds a bottom pipe obstacle at the specified Y center position.
 * Called by subclasses to create themed pipe implementations.
 * @param centerY The Y position center for the pipe gap
 */
- (void)addBottomPipe:(CGFloat)centerY;

@end
