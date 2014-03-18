//
//  EAUtils.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 20.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUtils.h"


@implementation EAUtils;

+ (float)randomFloatWithMin:(CGFloat)min max:(CGFloat)max
{
    return (float)floor(((rand() % RAND_MAX) / (RAND_MAX * 1.0)) * (max - min) + min);
}

+ (BOOL)isIPhone5
{
    return (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568.0f) < DBL_EPSILON);
}

+ (NSString *)assetName
{
    NSString *result = nil;
    
    if (![self isIPhone5]) {
        result = @"iPhone4";
    }
    else {
        result = @"iPhone5";
    }
    
    return result;
}

@end
