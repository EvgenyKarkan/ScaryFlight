//
//  EAHero.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAHero.h"

static CGFloat const kHeroDirection = 28.5f; // Controls upward flight impulse magnitude

@implementation EAHero;

/**
 * Applies upward impulse for flight mechanics.
 * The impulse magnitude is controlled by kHeroDirection constant.
 * Includes rotation calculation based on current zRotation for angled flight trajectory.
 * Prevents the hero from flying beyond the top screen boundary.
 * Also plays a jump sound effect on each flight action.
 */
- (void)flyWithYLimit:(CGFloat)yLimit
{
    NSParameterAssert(yLimit > 0.0f);

    // Built once - this runs on every tap, the hottest path in the game
    static SKAction *jumpSound = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jumpSound = [SKAction playSoundFileNamed:@"Jump.wav" waitForCompletion:NO];
    });

    if (self.position.y < yLimit - self.size.height / 2.0f) { // <-- avoid hero to fly away from top of screen
        CGFloat heroDirection = self.zRotation + (CGFloat)M_PI_2;
        self.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
        [self.physicsBody applyImpulse:CGVectorMake(kHeroDirection * cosf((float)heroDirection),
                                                    kHeroDirection * sinf((float)heroDirection))];
    }

    [self runAction:jumpSound];
}

@end
