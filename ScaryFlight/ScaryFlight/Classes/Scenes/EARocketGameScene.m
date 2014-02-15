//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "EAHero.h"
#import  "EAObstacle.h"



@implementation EARocketGameScene;

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
