//
//  EAScrollingSprite.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 17.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Horizontally scrolling background sprite node.
 * Creates a seamless looping background effect by tiling child sprites.
 * Used for cloud backgrounds in UFO mode to create parallax scrolling.
 */
@interface EAScrollingSprite : SKSpriteNode

/// Horizontal scrolling speed (default: 1.0)
@property (nonatomic, assign) CGFloat scrollingSpeed;

/**
 * Updates sprite positions for scrolling effect.
 * Should be called in the scene's update: method.
 * @param currentTime Current scene time
 */
- (void)update:(NSTimeInterval)currentTime;

@end
