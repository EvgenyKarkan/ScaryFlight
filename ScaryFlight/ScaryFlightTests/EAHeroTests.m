//
//  EAHeroTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAHero.h"

@interface EAHeroTests : XCTestCase

@property (nonatomic, strong) EAHero *hero;

@end

@implementation EAHeroTests

- (void)setUp
{
    [super setUp];

    self.hero = [EAHero spriteNodeWithImageNamed:@"UFO_new_hero"];
    self.hero.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.hero.size];
    self.hero.physicsBody.allowsRotation = NO;
}

- (void)tearDown
{
    self.hero = nil;
    [super tearDown];
}

#pragma mark - Creation

- (void)testHeroCreation
{
    XCTAssertNotNil(self.hero);
    XCTAssertTrue([self.hero isKindOfClass:[EAHero class]]);
}

#pragma mark - flyWithYLimit:

- (void)testFlyBelowLimitResetsHorizontalVelocity
{
    self.hero.position = CGPointMake(100.0f, 100.0f);
    self.hero.physicsBody.velocity = CGVectorMake(33.0f, -50.0f);

    [self.hero flyWithYLimit:500.0f];

    // Velocity is zeroed before the impulse; impulse is nearly vertical at zero rotation
    XCTAssertEqualWithAccuracy(self.hero.physicsBody.velocity.dx, 0.0f, 0.01f);
    XCTAssertGreaterThanOrEqual(self.hero.physicsBody.velocity.dy, -0.01f);
}

- (void)testFlyBelowLimitCancelsDownwardVelocity
{
    self.hero.position = CGPointMake(100.0f, 100.0f);
    self.hero.physicsBody.velocity = CGVectorMake(0.0f, -200.0f);

    [self.hero flyWithYLimit:500.0f];

    XCTAssertGreaterThan(self.hero.physicsBody.velocity.dy, -200.0f);
}

- (void)testFlyAboveLimitLeavesVelocityUntouched
{
    self.hero.position = CGPointMake(100.0f, 600.0f);
    self.hero.physicsBody.velocity = CGVectorMake(33.0f, -50.0f);

    [self.hero flyWithYLimit:500.0f];

    XCTAssertEqualWithAccuracy(self.hero.physicsBody.velocity.dx, 33.0f, 0.001f);
    XCTAssertEqualWithAccuracy(self.hero.physicsBody.velocity.dy, -50.0f, 0.001f);
}

- (void)testFlyExactlyAtBoundaryLeavesVelocityUntouched
{
    CGFloat yLimit = 500.0f;
    self.hero.position = CGPointMake(100.0f, yLimit - self.hero.size.height / 2.0f);
    self.hero.physicsBody.velocity = CGVectorMake(0.0f, -10.0f);

    [self.hero flyWithYLimit:yLimit];

    XCTAssertEqualWithAccuracy(self.hero.physicsBody.velocity.dy, -10.0f, 0.001f);
}

- (void)testFlyWithZeroLimitThrows
{
    XCTAssertThrows([self.hero flyWithYLimit:0.0f]);
}

- (void)testFlyWithNegativeLimitThrows
{
    XCTAssertThrows([self.hero flyWithYLimit:-100.0f]);
}

- (void)testFlyWithoutPhysicsBodyDoesNotCrash
{
    self.hero.physicsBody = nil;
    self.hero.position = CGPointMake(100.0f, 100.0f);

    XCTAssertNoThrow([self.hero flyWithYLimit:500.0f]);
}

@end
