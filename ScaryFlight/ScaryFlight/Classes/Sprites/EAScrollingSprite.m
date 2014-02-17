//
//  EAScrollingSprite.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 17.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAScrollingSprite.h"

@implementation EAScrollingSprite

+ (id)spriteNodeWithImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    
    EAScrollingSprite *realNode = [EAScrollingSprite spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(320.0f, image.size.height)];
    realNode.scrollingSpeed = 1;
    
    CGFloat total = 0.0f;
    while (total < (320.0f + image.size.width)) {
        SKSpriteNode *child = [SKSpriteNode spriteNodeWithImageNamed:name];
        [child setAnchorPoint:CGPointZero];
        [child setPosition:CGPointMake(total, 0.0f)];
        [realNode addChild:child];
        total += child.size.width;
    }
    
    return realNode;
}

- (void)update:(NSTimeInterval)currentTime
{
    [self.children enumerateObjectsUsingBlock: ^(SKSpriteNode *child, NSUInteger idx, BOOL *stop) {
        child.position = CGPointMake(child.position.x - self.scrollingSpeed, child.position.y);
        if (child.position.x <= -child.size.width) {
            CGFloat delta = child.position.x + child.size.width;
            child.position = CGPointMake(child.size.width * (self.children.count - 1) + delta, child.position.y);
        }
    }];
}

@end
