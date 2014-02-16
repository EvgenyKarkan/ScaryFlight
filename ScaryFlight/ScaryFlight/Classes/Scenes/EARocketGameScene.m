//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "EAMenuScene.h"
#import  "Constants.h"
@interface EARocketGameScene () <SKPhysicsContactDelegate>


@end


#import "EAHero.h"

//static uint32_t const kHeroCategory   = 0x1 << 0;
//static uint32_t const kGroundCategory = 0x1 << 2;
//static CGFloat const kPipeWidth     = 56.0f;
//static CGFloat const kPipeGap       = 80.0f;

@interface EARocketGameScene ()

@property (nonatomic, strong) SKSpriteNode *ground;

@end

@implementation EARocketGameScene;

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    

    self.hero.size = CGSizeMake(111.0f / 2.0f, 85.0f / 2.0f);
    [self addBottom];
}

- (void)addBottom
{
   
    self.ground = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(self.size.width, 30.0f)];
    //self.ground.size = CGSizeMake(self.size.width, 30.0f);
    self.ground.centerRect = CGRectMake(26.0f / 20.0f, 26.0f / 20.0f, 4.0f / 20.0f, 4.0f / 20.0f);
    self.ground.xScale = self.size.width / 20.0f;
    self.ground.zPosition = 1.0f;
    self.ground.position = CGPointMake(self.size.width / 2.0f, self.ground.size.height / 2.0f-self.ground.size.height);
    self.ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ground.size];
    self.ground.physicsBody.categoryBitMask = kGroundCategory;
    self.ground.physicsBody.collisionBitMask = kHeroCategory;
    self.ground.physicsBody.affectedByGravity = NO;
    self.ground.physicsBody.dynamic = NO;
    [self addChild:self.ground];
}

- (void)addObstacle
{
    CGFloat centerY = [self randomFloatWithMin:kPipeGap * 1.5f max:(self.size.height - kPipeGap * 1.5f)];
    
    self.pipeTop = [EAObstacle obstacleWithImageNamed:[self topObstacleImage]];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    [self.pipeTop moveObstacleWithScale:pipeTopHeight / kPipeWidth];
    self.pipeTop.position = CGPointMake(self.size.width + (self.pipeTop.size.width / 2.0f), self.size.height - (self.pipeTop.size.height / 2.0f));
    [self addChild:self.pipeTop];
    
    self.pipeBottom = [EAObstacle obstacleWithImageNamed:[self bottomObstacleImage]];
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [self.pipeBottom moveObstacleWithScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    self.pipeBottom.position = CGPointMake(self.size.width + (self.pipeBottom.size.width / 2.0f), (self.pipeBottom.size.height / 2.0f) + (kGroundHeight - 2.0f));
    [self addChild:self.pipeBottom];
}

-(NSString*)backgroundImageName{
    return @"Space";
}

-(NSString*)heroImageStateOne{
    return @"Rocket";
}

-(NSString*)heroImageStateTwo{
    return @"Rocket2";
}

-(NSString*)topObstacleImage{
    return @"AsteroidTop";
}

-(NSString*)bottomObstacleImage{
    return @"AsteroidDown";
}

@end
