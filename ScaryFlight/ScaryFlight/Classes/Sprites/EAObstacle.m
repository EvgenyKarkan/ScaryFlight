//
//  EAObstacle.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAObstacle.h"
#import "Constants.h"


@implementation EAObstacle;

#pragma mark - Designated initializer

/**
 * Factory method to create an obstacle sprite with proper validation.
 * Uses parameterized assertions to ensure valid image name.
 */
+ (instancetype)obstacleWithImageNamed:(NSString *)name
{
    NSParameterAssert(name != nil);
    NSParameterAssert([name length] > 0);
    NSParameterAssert(![name isEqualToString:@" "]);
    
    EAObstacle *obstacle = [super spriteNodeWithImageNamed:name];
    return obstacle;
}

#pragma mark - Public API

/**
 * Configures obstacle physics and starts horizontal movement.
 * Sets up texture stretching for variable height pipes.
 * Automatically removes obstacle when it scrolls off-screen.
 */
- (void)moveObstacleWithScale:(CGFloat)scale
{
    NSParameterAssert(scale > 0.0f);
    
    // Stretchable center area for texture scaling
    self.centerRect = CGRectMake(26.0f / kPipeWidth, 26.0f / kPipeWidth, 4.0f / kPipeWidth, 4.0f / kPipeWidth);
    
    // iOS version workaround for texture scaling
    if ([EAUtils isLessThanIOS_7_1]) {
        self.yScale = scale;
    }
    
    // Physics setup - obstacles don't move by physics, controlled by actions
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = kPipeCategory;
    self.physicsBody.collisionBitMask = kHeroCategory;
    
    if ([EAUtils isGreaterThanOrEqualToIOS_7_1]) {
        self.yScale = scale;
    }
    
    // Move left at constant speed, then remove when off-screen
    SKAction *pipeAction = [SKAction moveToX:-(self.size.width / 2.0f) duration:kPipeSpeed];
    
    __weak typeof(self) weakSelf = self;
    
    SKAction *pipeSequence = [SKAction sequence:@[pipeAction, [SKAction runBlock: ^{
        [weakSelf removeFromParent];
    }]]];
    
    [self runAction:[SKAction repeatActionForever:pipeSequence]];
}

@end
