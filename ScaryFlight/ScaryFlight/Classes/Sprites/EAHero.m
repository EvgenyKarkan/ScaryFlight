//
//  EAHero.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAHero.h"

static CGFloat const kHeroDirection = 25.0f;

@implementation EAHero;

- (void)fly
{
    CGFloat heroDirection = self.zRotation + M_PI_2;
    self.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
    [self.physicsBody applyImpulse:CGVectorMake(kHeroDirection * cosf(heroDirection),
                                                kHeroDirection * sinf(heroDirection))];
    
    [self runAction:[SKAction playSoundFileNamed:@"TouchNew.wav" waitForCompletion:NO]];
}

@end
