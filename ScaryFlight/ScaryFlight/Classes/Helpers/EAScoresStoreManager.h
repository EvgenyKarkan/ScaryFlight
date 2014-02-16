//
//  EAScoresStoreManager.h
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/16/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAScoresStoreManager : NSObject
+(void)setTopScore:(NSUInteger)topScore;
+(NSUInteger)getTopScore;

@end
