//
//  EAHero.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Player-controlled hero sprite that flies through obstacles.
 * Supports animated sprite textures and physics-based movement.
 * Used for both UFO and Rocket variants in their respective game scenes.
 */
@interface EAHero : SKSpriteNode

/**
 * Applies upward impulse to the hero for flight mechanics.
 * @param yLimit The maximum Y position to prevent flying off-screen
 */
- (void)flyWithYLimit:(CGFloat)yLimit;

@end
