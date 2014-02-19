//
//  EAScrollingSprite.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 17.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//


@interface EAScrollingSprite : SKSpriteNode

@property (nonatomic, assign) CGFloat scrollingSpeed;

- (void) update:(NSTimeInterval)currentTime;

@end
