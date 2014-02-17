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

static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kGroundCategory = 0x1 << 2;


@interface EAUFOGameScene ()

@property (nonatomic, strong) SKSpriteNode *ground;
@property (nonatomic, strong) EAScrollingSprite *clouds;

@end


@implementation EAUFOGameScene;

#pragma mark - SKScene overriden API

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
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:1000];
    
    self.clouds = [EAScrollingSprite spriteNodeWithImageNamed:@"Clouds"];

    self.clouds.position = CGPointMake(0, self.size.height - 15.0f);
    self.clouds.scrollingSpeed = 1.0f;
    [self addChild:self.clouds];
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    [self.clouds update:currentTime];
}

- (NSString *)backgroundImageName
{
    return @"City";
}

- (NSString *)heroImageStateOne
{
    return @"UFO_new_hero";
}

- (NSString *)heroImageStateTwo
{
    return @"UFO_new_hero2";
}

- (NSString *)topObstacleImage
{
    return @"UFO_top_pipe";
}

- (NSString *)bottomObstacleImage
{
    return @"UFO_down_pipe";
}

@end
