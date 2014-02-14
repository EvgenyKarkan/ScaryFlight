//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"

@implementation EARocketGameScene;

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.backgroundColor = [SKColor yellowColor];
    [self addBackground];
}

- (void)update:(NSTimeInterval)currentTime{
    
}

- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Space"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}

    
//    CGPoint clickPoint = [theEvent locationInNode:self.playerNode.parent];
//    
//    CGPoint charPos = self.playerNode.position;
//    
//    CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
//                             
//                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
//    
//    
//    
//    SKAction *moveToClick = [SKAction moveTo:clickPoint duration:distance/characterSpeed];
//    
//    [self.playerNode runAction:moveToClick withKey:@"moveToClick"];

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    //CGPoint positionInScene = [touch locationInNode:self];
    //[self selectNodeForTouch:positionInScene];
}

@end
