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

- (void)addBottomPipe:(CGFloat)centerY;

@end
