//
//  EAMenuScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAMenuScene.h"
#import "EAUFOGameScene.h"
#import "EARocketGameScene.h"
#import "EKMusicPlayer.h"
#import "EAHero.h"

@interface EAMenuScene ()

@property (nonatomic, strong) EAHero            *ufoButton;
@property (nonatomic, strong) EAHero            *rocketButton;
@property (nonatomic, strong) EAUFOGameScene    *ufoScene;
@property (nonatomic, strong) EARocketGameScene *rocketScene;

@end


@implementation EAMenuScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    //[self createBackgroundAnimation];
    self.backgroundColor = [SKColor orangeColor];
    
    self.ufoScene = [[EAUFOGameScene alloc] initWithSize:self.size];
    self.rocketScene = [[EARocketGameScene alloc] initWithSize:self.size];
    
    [self createSpriteButtons];
    
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:1000];
}

- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    
    [[EKMusicPlayer sharedInstance] stop];
}

#pragma mark - UIResponder overriden API

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    if (CGRectContainsPoint(self.ufoButton.frame, positionInScene)) {
        [self.scene.view presentScene:self.ufoScene];
    }
    else if (CGRectContainsPoint(self.rocketButton.frame, positionInScene)) {
        [self.scene.view presentScene:self.rocketScene];
    }
}

#pragma mark - Private API

- (void)createSpriteButtons
{
    [self createUfoButton];
    [self createRocketButton];
}

- (void)createUfoButton
{
    self.ufoButton = [EAHero spriteNodeWithImageNamed:@"UFO_new_hero"];
    self.ufoButton.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    [self.ufoButton setPosition:CGPointMake(CGRectGetMidX(self.view.frame),
                                            CGRectGetMidY(self.view.frame) + 150.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"UFO_new_hero"],
                                 [SKTexture textureWithImageNamed:@"UFO_new_hero2"]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.ufoButton runAction:heroAction withKey:@"flyingHeroUfo"];
    [self addChild:self.ufoButton];
}

- (void)createRocketButton
{
    self.rocketButton = [EAHero spriteNodeWithImageNamed:@"Rocket"];
    self.rocketButton.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    [self.rocketButton setPosition:CGPointMake(CGRectGetMidX(self.view.frame) - 2.5,
                                               CGRectGetMidY(self.view.frame) + 50.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"Rocket"],
                                 [SKTexture textureWithImageNamed:@"Rocket2"]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.rocketButton runAction:heroAction withKey:@"flyingHeroRocket"];
    [self addChild:self.rocketButton];
}

@end
