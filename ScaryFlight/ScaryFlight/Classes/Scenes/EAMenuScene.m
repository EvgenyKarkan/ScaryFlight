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

@property (nonatomic, strong) EAHero       *ufoButton;
@property (nonatomic, strong) EAHero       *rocketButton;
@property (nonatomic, strong) SKSpriteNode *rankButton;

@end


@implementation EAMenuScene;

#pragma mark - SKScene overriden API

/**
 * Initializes menu scene - creates background, labels, and animated buttons.
 * Starts looping menu background music.
 * Game scenes are not created here - touchesBegan: builds the picked one lazily.
 */
- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

    [self provideBackground];
    [self addLabels];
    [self createSpriteButtons];
    
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:-1];
}

/**
 * Stops menu music when leaving the menu scene.
 */
- (void)willMoveFromView:(SKView *)view
{
    [super willMoveFromView:view];
    [[EKMusicPlayer sharedInstance] stop];
}

/**
 * Updates score display and reports to Game Center when player beats top score.
 * Reports stored score once if Game Center becomes authenticated mid-game.
 */
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

/**
 * Handles touch events for menu button interactions.
 * Transitions to UFO scene, Rocket scene, or displays Game Center leaderboard.
 * Game scenes are created lazily here so each visit to the menu
 * allocates only the scene the player actually picks.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];

    if (CGRectContainsPoint(self.ufoButton.frame, positionInScene)) {
        [self.scene.view presentScene:[[EAUFOGameScene alloc] initWithSize:self.size]];
    }
    else if (CGRectContainsPoint(self.rocketButton.frame, positionInScene)) {
        [self.scene.view presentScene:[[EARocketGameScene alloc] initWithSize:self.size]];
    }
    else if (CGRectContainsPoint(self.rankButton.frame, positionInScene)) {
        [[EAGameCenterProvider sharedInstance] showLeaderboard];
    }
}

#pragma mark - Private API

/**
 * Creates interactive menu buttons for game mode selection and leaderboard.
 * Each button has animated sprite textures for visual feedback.
 */
- (void)createSpriteButtons
{
    [self createUfoButton];
    [self createRocketButton];
    [self createRankButton];
}

/**
 * Creates animated UFO button for selecting UFO game mode.
 * Positions button on left side of screen with blinking animation.
 */
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

/**
 * Creates animated Rocket button for selecting Rocket game mode.
 * Positions button on right side of screen with blinking animation.
 */
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

/**
 * Creates the rank/leaderboard button for displaying Game Center scores.
 */
- (void)createRankButton
{
    self.rankButton = [EAHero spriteNodeWithImageNamed:@"Places"];
    self.rankButton.position = CGPointMake(CGRectGetMidX(self.view.frame) - self.rankButton.frame.size.width / 128.0f,
                                           self.position.y + 25.0f);
    [self addChild:self.rankButton];
}

/**
 * Sets up background image based on device type (iPhone 4 vs iPhone 5).
 * Uses EAUtils to determine appropriate asset name.
 */
- (void)provideBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:[EAUtils assetName]];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    background.zPosition = 0.0;
    [self addChild:background];
}

/**
 * Creates title labels "Scary" and "Flight" with styling and positioning.
 * Uses PressStart2P font with yellow color for retro arcade feel.
 */
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
