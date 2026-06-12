//
//  EAObstacle.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Obstacle sprite that moves horizontally across the screen.
 * Used for pipes (UFO mode) or asteroids (Rocket mode).
 * Creates a physics body for collision detection and handles
 * automatic movement with removal when off-screen.
 */
@interface EAObstacle : SKSpriteNode

/**
 * Creates an obstacle sprite with the specified image name.
 * @param name The name of the image in the asset catalog
 * @return A new EAObstacle instance
 */
+ (instancetype)obstacleWithImageNamed:(NSString *)name;

/**
 * Configures obstacle physics and starts horizontal movement animation.
 * @param scale The vertical scale factor for the obstacle
 */
- (void)moveObstacleWithScale:(CGFloat)scale;

@end
