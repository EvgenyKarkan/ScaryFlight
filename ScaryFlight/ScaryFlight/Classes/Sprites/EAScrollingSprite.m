//
//  EAScrollingSprite.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 17.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScrollingSprite.h"


@interface EAScrollingSprite ()

/// Snapshot of the tile nodes - SKNode.children copies an array on every
/// access, which is too expensive for a per-frame update loop
@property (nonatomic, strong) NSArray *tiles;

@end


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

    node.tiles = node.children;

    return node;
}

#pragma mark - Overriden SKSpriteNode API

/**
 * Updates child sprite positions each frame for scrolling.
 * Wraps children to the end when they scroll off the left edge.
 * Called by parent scene in its update: method.
 * Iterates the cached tile snapshot to avoid per-frame array copies.
 */
- (void)update:(NSTimeInterval)currentTime
{
    NSUInteger tilesCount = self.tiles.count;
    CGFloat scrollingSpeed = self.scrollingSpeed;

    for (SKNode *child in self.tiles) {
        child.position = CGPointMake(child.position.x - scrollingSpeed, child.position.y);

        CGFloat childWidth = child.frame.size.width;

        if (child.position.x <= -childWidth) {
            CGFloat delta = child.position.x + childWidth;
            child.position = CGPointMake(childWidth * (tilesCount - 1) + delta, child.position.y);
        }
    }
}

@end
