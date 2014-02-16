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

static uint32_t const kHeroCategory = 0x1 << 0;
static uint32_t const kPipeCategory = 0x1 << 1;


@implementation EAObstacle;

#pragma mark - Designated initializer

+ (instancetype)obstacleWithImageNamed:(NSString *)name
{
    NSParameterAssert(name != nil);
    NSParameterAssert([name length] > 0);
    NSParameterAssert(![name isEqualToString:@" "]);
    
    EAObstacle *obstacle = [super spriteNodeWithImageNamed:name];
    return obstacle;
}

#pragma mark - Public API

- (void)moveObstacleWithScale:(CGFloat)scale
{
    NSParameterAssert(scale > 0.0f);
    
    self.centerRect = CGRectMake(26.0f / kPipeWidth, 26.0f / kPipeWidth, 4.0f / kPipeWidth, 4.0f / kPipeWidth);
    self.yScale = scale;
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = kPipeCategory;
    self.physicsBody.collisionBitMask = kHeroCategory;
    
    SKAction *pipeAction = [SKAction moveToX:-(self.size.width / 2.0f) duration:kPipeSpeed];
    
    __weak typeof(self) weakSelf = self;
    
    SKAction *pipeSequence = [SKAction sequence:@[pipeAction, [SKAction runBlock: ^{
        [weakSelf removeFromParent];
    }]]];
    
    [self runAction:[SKAction repeatActionForever:pipeSequence]];
}

@end
