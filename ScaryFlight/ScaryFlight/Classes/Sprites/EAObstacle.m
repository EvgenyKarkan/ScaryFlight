//
//  EAObstacle.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAObstacle.h"

static CGFloat const kPipeSpeed     = 4.5f;
static CGFloat const kPipeWidth     = 56.0f;
static CGFloat const kPipeGap       = 80.0f;
static CGFloat const kPipeFrequency = 2.5f;

static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;

@implementation EAObstacle

- (void)moveObstacleWithHeight:(CGFloat)height
{
    self.centerRect = CGRectMake(26.0f / kPipeWidth, 26.0f / kPipeWidth, 4.0f / kPipeWidth, 4.0f / kPipeWidth);
    self.yScale = height / kPipeWidth;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = kPipeCategory;
    self.physicsBody.collisionBitMask = kHeroCategory;
    
    SKAction *pipeTopAction = [SKAction moveToX:-(self.size.width / 2) duration:kPipeSpeed];
    SKAction *pipeTopSequence = [SKAction sequence:@[pipeTopAction, [SKAction runBlock: ^{
        [self removeFromParent];
    }]]];
    
    [self runAction:[SKAction repeatActionForever:pipeTopSequence]];
}

@end
