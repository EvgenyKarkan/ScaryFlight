//
//  EAObstacle.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//


@interface EAObstacle: SKSpriteNode

+ (instancetype)obstacleWithImageNamed:(NSString *)name;
- (void)moveObstacleWithScale:(CGFloat)scale;

@end
