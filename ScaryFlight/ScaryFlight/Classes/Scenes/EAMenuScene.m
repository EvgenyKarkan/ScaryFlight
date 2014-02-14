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

@interface EAMenuScene ()

@property (nonatomic, strong) SKSpriteNode *ufoButton;
@property (nonatomic, strong) SKSpriteNode *rocketButton;

@end


@implementation EAMenuScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.backgroundColor = [SKColor orangeColor];
    
    [self createSpriteButtons];
}

#pragma mark - Private API

- (void)createSpriteButtons
{
    CGPoint location = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) + 150.0f);
    
    self.ufoButton = [SKSpriteNode spriteNodeWithImageNamed:@"UFOButton"];
    self.ufoButton.position = location;
    [self addChild:self.ufoButton];
    
    CGPoint location2 = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame) + 50.0f);;
    
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
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5f];
        EAUFOGameScene *ufoScene = [[EAUFOGameScene alloc] initWithSize:self.size];
        [self.scene.view presentScene:ufoScene
                           transition:reveal];
    }
    else if (CGRectContainsPoint(self.rocketButton.frame, positionInScene)) {
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5f];
        EARocketGameScene *rocketScene = [[EARocketGameScene alloc] initWithSize:self.size];
        [self.scene.view presentScene:rocketScene
                           transition:reveal];
    }
}

@end
