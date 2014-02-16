//
//  EAUFOGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUFOGameScene.h"

@interface EAUFOGameScene ()

@property (nonatomic, strong) SKSpriteNode *ground;

@end


@implementation EAUFOGameScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    [self.ground setCenterRect:CGRectMake(26.0 / 20, 26.0 / 20, 4.0 / 20, 4.0 / 20)];
    [self.ground setXScale:self.size.width / 20];
    self.ground.zPosition = 1.0f;
    [self.ground setPosition:CGPointMake(self.size.width / 2, self.ground.size.height / 2)];
    [self addChild:self.ground];

}


-(NSString*)backgroundImageName{
    return @"City";
}

-(NSString*)heroImageStateOne{
    return @"UFO_new_hero";
}

-(NSString*)heroImageStateTwo{
    return @"UFO_new_hero2";
}

-(NSString*)topObstacleImage{
    return @"UFO_top_pipe";
}

-(NSString*)bottomObstacleImage{
    return @"UFO_down_pipe";
}

@end
