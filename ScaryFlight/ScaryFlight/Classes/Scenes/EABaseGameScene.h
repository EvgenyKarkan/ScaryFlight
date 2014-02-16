//
//  EABaseGameScene.h
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/15/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAHero.h"
#import "EAObstacle.h"
@interface EABaseGameScene : SKScene

@property (nonatomic, strong) EAHero *hero;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic ,strong) SKLabelNode * scoresLabel;
@property (nonatomic ,assign) NSUInteger  scores;
@property (nonatomic ,strong) EAObstacle *pipeTop;
@property (nonatomic ,strong) EAObstacle *lastPipe;

- (void)didBeginContact:(SKPhysicsContact *)contact;

@end
