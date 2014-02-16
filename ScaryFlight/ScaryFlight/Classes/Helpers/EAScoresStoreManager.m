//
//  EAScoresStoreManager.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScoresStoreManager.h"
static  NSString * kTopScore= @"kTopScore";

@implementation EAScoresStoreManager

+(void)saveTopScore:(NSInteger)topScore{
    
    NSString *valueToSave = [NSString stringWithFormat:@"%ld",(long)topScore];
    [[NSUserDefaults standardUserDefaults]
     setObject:valueToSave forKey:kTopScore];

}

+(NSInteger)getTopScore{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:kTopScore];
    
    return [savedValue integerValue];
}


@end
