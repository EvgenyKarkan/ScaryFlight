//
//  EAUFOGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUFOGameScene.h"
#import "EAHero.h"
#import "EKMusicPlayer.h"
#import "EAScrollingSprite.h"
#import "Constants.h"


@interface EAUFOGameScene ()

@property (nonatomic, strong) SKSpriteNode *ground;
@property (nonatomic, strong) EAScrollingSprite *clouds;

@end


@implementation EAUFOGameScene;

#pragma mark - SKScene overriden API

/**
 * Sets up UFO game scene with ground platform, cloud background, and music.
 * Ground provides collision boundary at bottom of screen.
 * Clouds create parallax scrolling effect via EAScrollingSprite.
 */
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    self.ground.size = CGSizeMake(self.size.width, 30.0f);
    self.ground.centerRect = CGRectMake(26.0f / 20.0f, 26.0f / 20.0f, 4.0f / 20.0f, 4.0f / 20.0f);
    self.ground.xScale = self.size.width / 20.0f;
    self.ground.zPosition = 1.0f;
    self.ground.position = CGPointMake(self.size.width / 2.0f, self.ground.size.height / 2.0f);
    self.ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.ground.size];
    self.ground.physicsBody.categoryBitMask = kGroundCategory;
    self.ground.physicsBody.collisionBitMask = kHeroCategory;
    self.ground.physicsBody.affectedByGravity = NO;
    self.ground.physicsBody.dynamic = NO;
    [self addChild:self.ground];
    
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"CityFlightSound.mp3"];
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:-1];
    
    self.clouds = [EAScrollingSprite spriteNodeWithImageNamed:@"Clouds"];
    self.clouds.position = CGPointMake(0, self.size.height - 15.0f);
    self.clouds.scrollingSpeed = 1.0f;
    [self addChild:self.clouds];
}

/**
 * Updates cloud scrolling animation.
 * Called every frame to maintain parallax effect.
 */
- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    [self.clouds update:currentTime];
}

#pragma mark - Overriden inherited private API

/**
 * Provides asset names for UFO-themed game elements.
 * Used by base class methods to create themed sprites.
 */
- (NSString *)backgroundImageName
{
    return @"City";
}

/**
 * UFO hero animation frame one - initial sprite
 */
- (NSString *)heroImageStateOne
{
    return @"UFO_new_hero";
}

/**
 * UFO hero animation frame two - blinking effect
 */
- (NSString *)heroImageStateTwo
{
    return @"UFO_new_hero2";
}

/**
 * Top pipe image name for UFO obstacles
 */
- (NSString *)topObstacleImage
{
    return @"UFO_top_pipe";
}

/**
 * Bottom pipe image name for UFO obstacles
 */
- (NSString *)bottomObstacleImage
{
    return @"UFO_down_pipe";
}

@end
