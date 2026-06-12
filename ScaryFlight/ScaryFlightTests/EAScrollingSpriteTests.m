//
//  EAScrollingSpriteTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAScrollingSprite.h"

@interface EAScrollingSpriteTests : XCTestCase

@property (nonatomic, strong) EAScrollingSprite *sprite;

@end

@implementation EAScrollingSpriteTests

- (void)setUp
{
    [super setUp];
    self.sprite = [EAScrollingSprite spriteNodeWithImageNamed:@"Clouds"];
}

- (void)tearDown
{
    self.sprite = nil;
    [super tearDown];
}

#pragma mark - Creation

- (void)testSpriteCreation
{
    XCTAssertNotNil(self.sprite);
    XCTAssertTrue([self.sprite isKindOfClass:[EAScrollingSprite class]]);
}

- (void)testDefaultScrollingSpeedIsOne
{
    XCTAssertEqualWithAccuracy(self.sprite.scrollingSpeed, 1.0f, 0.001f);
}

- (void)testSpriteWidthMatchesScreenWidth
{
    XCTAssertEqualWithAccuracy(self.sprite.size.width, 320.0f, 0.001f);
}

- (void)testSpriteHeightMatchesImageHeight
{
    UIImage *image = [UIImage imageNamed:@"Clouds"];
    XCTAssertEqualWithAccuracy(self.sprite.size.height, image.size.height, 0.001f);
}

- (void)testChildrenTileTheFullWidth
{
    XCTAssertGreaterThan(self.sprite.children.count, (NSUInteger)0);

    UIImage *image = [UIImage imageNamed:@"Clouds"];
    CGFloat coveredWidth = 0.0f;

    for (SKSpriteNode *child in self.sprite.children) {
        coveredWidth += child.size.width;
    }

    XCTAssertGreaterThanOrEqual(coveredWidth, 320.0f + image.size.width,
                                @"Tiles must cover the screen plus one extra tile for seamless wrapping");
}

- (void)testChildrenArePositionedSequentially
{
    CGFloat expectedX = 0.0f;

    for (SKSpriteNode *child in self.sprite.children) {
        XCTAssertEqualWithAccuracy(child.position.x, expectedX, 0.001f);
        XCTAssertEqualWithAccuracy(child.position.y, 0.0f, 0.001f);
        XCTAssertEqualWithAccuracy(child.anchorPoint.x, 0.0f, 0.001f);
        XCTAssertEqualWithAccuracy(child.anchorPoint.y, 0.0f, 0.001f);
        expectedX += child.size.width;
    }
}

#pragma mark - update:

- (void)testUpdateMovesChildrenLeftByScrollingSpeed
{
    NSMutableArray *initialPositions = [NSMutableArray array];
    for (SKNode *child in self.sprite.children) {
        [initialPositions addObject:@(child.position.x)];
    }

    [self.sprite update:0.0];

    [self.sprite.children enumerateObjectsUsingBlock: ^(SKNode *child, NSUInteger idx, BOOL *stop) {
        CGFloat initialX = (CGFloat)[initialPositions[idx] doubleValue];
        XCTAssertEqualWithAccuracy(child.position.x, initialX - 1.0f, 0.001f);
    }];
}

- (void)testUpdateRespectsCustomScrollingSpeed
{
    self.sprite.scrollingSpeed = 3.5f;
    SKNode *firstChild = self.sprite.children.firstObject;
    CGFloat initialX = firstChild.position.x;

    [self.sprite update:0.0];

    XCTAssertEqualWithAccuracy(firstChild.position.x, initialX - 3.5f, 0.001f);
}

- (void)testUpdateWrapsChildToTheEndWhenOffScreen
{
    SKNode *firstChild = self.sprite.children.firstObject;
    CGFloat childWidth = firstChild.frame.size.width;

    // Place the child just before the wrap threshold so one update pushes it past
    firstChild.position = CGPointMake(-childWidth + 0.5f, 0.0f);

    [self.sprite update:0.0];

    CGFloat expectedX = childWidth * (self.sprite.children.count - 1) + (-childWidth - 0.5f + childWidth);
    XCTAssertEqualWithAccuracy(firstChild.position.x, expectedX, 0.001f);
    XCTAssertGreaterThan(firstChild.position.x, 0.0f, @"Wrapped child must reappear on the right side");
}

- (void)testRepeatedUpdatesKeepChildrenWithinScrollBand
{
    SKNode *firstChild = self.sprite.children.firstObject;
    CGFloat childWidth = firstChild.frame.size.width;
    CGFloat maxX = childWidth * self.sprite.children.count;

    for (NSUInteger i = 0; i < 5000; i++) {
        [self.sprite update:0.0];
    }

    for (SKNode *child in self.sprite.children) {
        XCTAssertGreaterThan(child.position.x, -childWidth - 0.001f);
        XCTAssertLessThan(child.position.x, maxX + 0.001f);
    }
}

@end
