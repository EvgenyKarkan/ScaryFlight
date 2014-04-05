//
//  EAUtils.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 20.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//


@interface EAUtils : NSObject

+ (float)randomFloatWithMin:(CGFloat)min max:(CGFloat)max;
+ (BOOL)isIPhone5;
+ (BOOL)isLessThanIOS_7_1;
+ (BOOL)isGreaterThanOrEqualToIOS_7_1;
+ (NSString *)assetName;

@end
