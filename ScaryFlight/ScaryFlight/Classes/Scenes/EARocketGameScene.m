//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "EAHero.h"

@implementation EARocketGameScene;

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    EAHero *referenceHero = [self performSelector:@selector(hero)];
    
#pragma clang diagnostic pop
    
    referenceHero.size = CGSizeMake(111.0f / 2.0f, 85.0f / 2.0f);
}

-(NSString*)backgroundImageName{
    return @"Space";
}

-(NSString*)heroImageStateOne{
    return @"Rocket";
}

-(NSString*)heroImageStateTwo{
    return @"Rocket2";
}

-(NSString*)topObstacleImage{
    return @"AsteroidTop";
}

-(NSString*)bottomObstacleImage{
    return @"AsteroidDown";
}

@end
