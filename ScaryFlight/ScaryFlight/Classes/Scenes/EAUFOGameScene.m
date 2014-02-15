//
//  EAUFOGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUFOGameScene.h"


@implementation EAUFOGameScene;

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
