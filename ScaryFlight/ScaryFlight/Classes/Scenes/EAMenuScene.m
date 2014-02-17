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


@interface EAMenuScene ()

@property (nonatomic, strong) SKSpriteNode      *ufoButton;
@property (nonatomic, strong) SKSpriteNode      *rocketButton;
@property (nonatomic, strong) EAUFOGameScene    *ufoScene;
@property (nonatomic, strong) EARocketGameScene *rocketScene;
@property (nonatomic, strong) SKAction *play;
@end


@implementation EAMenuScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
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

#pragma mark - Private API

- (void)createSpriteButtons
{
    CGPoint location = CGPointMake(CGRectGetMidX(self.view.frame),
                                   CGRectGetMidY(self.view.frame) + 150.0f);
    
    self.ufoButton = [SKSpriteNode spriteNodeWithImageNamed:@"UFOButton"];
    self.ufoButton.position = location;
    [self addChild:self.ufoButton];
    
    CGPoint location2 = CGPointMake(CGRectGetMidX(self.view.frame),
                                    CGRectGetMidY(self.view.frame) + 50.0f);
    
    self.rocketButton = [SKSpriteNode spriteNodeWithImageNamed:@"RocketButton"];
    self.rocketButton.position = location2;
    [self addChild:self.rocketButton];
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

@end
