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
#import "EAGameCenterProvider.h"
#import "EAScoresStoreManager.h"


@interface EAMenuScene ()

@property (nonatomic, strong) EAHero            *ufoButton;
@property (nonatomic, strong) EAHero            *rocketButton;
@property (nonatomic, strong) EAUFOGameScene    *ufoScene;
@property (nonatomic, strong) EARocketGameScene *rocketScene;
@property (nonatomic, strong) SKSpriteNode      *rankButton;

@end


@implementation EAMenuScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.ufoScene = [[EAUFOGameScene alloc] initWithSize:self.size];
    self.rocketScene = [[EARocketGameScene alloc] initWithSize:self.size];
    
    [self provideBackground];
    [self addLabels];
    [self createSpriteButtons];
    
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:-1];
}

- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    [[EKMusicPlayer sharedInstance] stop];
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
        //check & handle if player get top score during unauthorized game center state
    if ([EAScoresStoreManager getTopScore] > 0 && [EAGameCenterProvider sharedInstance].userAuthenticated) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[EAGameCenterProvider sharedInstance] reportScore:[EAScoresStoreManager getTopScore]];
        });
    }
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
    else if (CGRectContainsPoint(self.rankButton.frame, positionInScene)) {
        [[EAGameCenterProvider sharedInstance] showLeaderboard];
    }
}

#pragma mark - Private API

- (void)createSpriteButtons
{
    [self createUfoButton];
    [self createRocketButton];
    [self createRankButton];
}

- (void)createUfoButton
{
    self.ufoButton = [EAHero spriteNodeWithImageNamed:@"UFO_new_hero"];
    self.ufoButton.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    [self.ufoButton setPosition:CGPointMake(CGRectGetMidX(self.view.frame) - 70.0f,
                                            CGRectGetMidY(self.view.frame) - 60.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"UFO_new_hero"],
                                 [SKTexture textureWithImageNamed:@"UFO_new_hero2"]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.ufoButton runAction:heroAction];
    [self addChild:self.ufoButton];
}

- (void)createRocketButton
{
    self.rocketButton = [EAHero spriteNodeWithImageNamed:@"Rocket"];
    self.rocketButton.size = CGSizeMake(111.0f / 2.0f, 85.0f / 2.0f);
    [self.rocketButton setPosition:CGPointMake(CGRectGetMidX(self.view.frame) + 70.0f,
                                               CGRectGetMidY(self.view.frame) - 60.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"Rocket"],
                                 [SKTexture textureWithImageNamed:@"Rocket2"]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.rocketButton runAction:heroAction];
    [self addChild:self.rocketButton];
}

- (void)createRankButton
{
    self.rankButton = [EAHero spriteNodeWithImageNamed:@"Places"];
    self.rankButton.position = CGPointMake(CGRectGetMidX(self.view.frame) - self.rankButton.frame.size.width / 128.0f,
                                           self.position.y + 25.0f);
    [self addChild:self.rankButton];
}

- (void)provideBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:[EAUtils assetName]];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    background.zPosition = 0.0;
    [self addChild:background];
}

- (void)addLabels
{
    SKLabelNode *titleLabel = [[SKLabelNode alloc] initWithFontNamed:@"PressStart2P"];
    titleLabel.text = @"Scary";
    titleLabel.fontSize = 50.0f;
    titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    titleLabel.fontColor = [SKColor yellowColor];
    titleLabel.position = CGPointMake(self.frame.origin.x + 35.0f, self.frame.size.height - 110.0f);
    [self addChild:titleLabel];
    
    SKLabelNode *titleLabel2 = [[SKLabelNode alloc] initWithFontNamed:@"PressStart2P"];
    titleLabel2.text = @"Flight";
    titleLabel2.fontSize = 50.0f;
    titleLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    titleLabel2.fontColor = [SKColor yellowColor];
    titleLabel2.position = CGPointMake(self.frame.origin.x + 15.0f, self.frame.size.height - 170.0f);
    [self addChild:titleLabel2];
    
    SKLabelNode *titleLabel3 = [[SKLabelNode alloc] initWithFontNamed:@"PressStart2P"];
    titleLabel3.text = @"select flight";
    titleLabel3.fontSize = 12.0f;
    titleLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    titleLabel3.fontColor = [SKColor cyanColor];
    titleLabel3.position = CGPointMake(CGRectGetMidX(self.view.frame) - titleLabel3.frame.size.width / 2.0f, self.frame.size.height - 250.0f);
    [self addChild:titleLabel3];
}

@end
