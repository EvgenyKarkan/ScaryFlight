//
//  EAScoresStoreManager.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScoresStoreManager.h"

@implementation EAScoresStoreManager

+(void)saveTopScore:(NSInteger)topScore{
    
    
    
    NSString *valueToSave = @"someValue";
    [[NSUserDefaults standardUserDefaults]
     setObject:valueToSave forKey:@"preferenceName"];
    
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"preferenceName"];
    

}

@end
