//
//  EAScrollingSprite.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 17.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScrollingSprite.h"


@implementation EAScrollingSprite;

#pragma mark - Designated initializer

/**
 * Creates a horizontally-scrolling sprite with tiled child sprites.
 * Builds a seamless loop by creating multiple copies of the image.
 * Children wrap around when scrolled off-screen to create infinite scroll effect.
 * TODO: Add iPad support (currently hardcoded to 320.0f width).
 */
+ (instancetype)spriteNodeWithImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    EAScrollingSprite *node = [EAScrollingSprite spriteNodeWithColor:[UIColor clearColor]
                                                                size:CGSizeMake(320.0f /* to add here support for iPad */, image.size.height)];
    node.scrollingSpeed = 1.0f;
    
    CGFloat total = 0.0f;
    
    while (total < (320.0f /* to add here support for iPad */ + image.size.width)) {
        SKSpriteNode *child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0.0f)];
        [node addChild:child];
        total += child.size.width;
    }
    
    return node;
}

#pragma mark - Overriden SKSpriteNode API

/**
 * Updates child sprite positions each frame for scrolling.
 * Wraps children to the end when they scroll off the left edge.
 * Called by parent scene in its update: method.
 */
- (void)update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock: ^(SKNode *child, NSUInteger idx, BOOL *stop) {
        
        child.position = CGPointMake(child.position.x - self.scrollingSpeed, child.position.y);
        
        if (child.position.x <= -child.frame.size.width) {
            CGFloat delta = child.position.x + child.frame.size.width;
            child.position = CGPointMake(child.frame.size.width * (self.children.count - 1) + delta, child.position.y);
        }
    }];
}

@end
