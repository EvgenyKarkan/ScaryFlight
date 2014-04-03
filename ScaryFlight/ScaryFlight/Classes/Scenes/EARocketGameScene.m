//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "Constants.h"
#import "EKMusicPlayer.h"

@interface EARocketGameScene ()

@property (nonatomic, strong) SKSpriteNode *ground;

@end


@implementation EARocketGameScene;

#pragma mark - Overriden SKScene API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.hero.size = CGSizeMake(116.0f / 2.0f, 91.0f / 2.0f);
    [self addBottom];
    
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"SpaceFlightSound.mp3"];
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:-1];
}

#pragma mark - Private API

- (void)addBottom
{
    self.ground = [SKSpriteNode spriteNodeWithColor:[SKColor grayColor] size:CGSizeMake(self.size.width, 30.0f)];
    self.ground.centerRect = CGRectMake(26.0f / 20.0f, 26.0f / 20.0f, 4.0f / 20.0f, 4.0f / 20.0f);
    self.ground.xScale = self.size.width / 20.0f;
    self.ground.zPosition = 1.0f;
    self.ground.position = CGPointMake(self.size.width / 2.0f, self.ground.size.height / 2.0f - self.ground.size.height - 50.0f);
    self.ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ground.size];
    self.ground.physicsBody.categoryBitMask = kGroundCategory;
    self.ground.physicsBody.collisionBitMask = kHeroCategory;
    self.ground.physicsBody.affectedByGravity = NO;
    self.ground.physicsBody.dynamic = NO;
    [self addChild:self.ground];
}

#pragma mark - Overriden private API

- (void)addBottomPipe:(CGFloat)centerY
{
    [super addBottomPipe:centerY];
    
    EAObstacle *pipeBottom = [EAObstacle obstacleWithImageNamed:[self bottomObstacleImage]];
    [self addChild:pipeBottom];
    
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [pipeBottom moveObstacleWithScale:(pipeBottomHeight) / kPipeWidth];
    pipeBottom.position = CGPointMake(self.size.width + (pipeBottom.size.width / 2.0f), (pipeBottom.size.height / 2.0f));
}

- (NSString *)backgroundImageName
{
    return @"Space";
}

- (NSString *)heroImageStateOne
{
    return @"Rocket";
}

- (NSString *)heroImageStateTwo
{
    return @"Rocket2";
}

- (NSString *)topObstacleImage
{
    return @"AsteroidTop";
}

- (NSString *)bottomObstacleImage
{
    return @"AsteroidDown";
}

@end
