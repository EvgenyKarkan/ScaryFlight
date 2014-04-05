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
+ (BOOL)isIOS_7_0;
+ (BOOL)isGreaterThanIOS_7_0;
+ (NSString *)assetName;

@end
