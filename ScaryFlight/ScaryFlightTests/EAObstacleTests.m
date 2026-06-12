//
//  EAObstacleTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAObstacle.h"
#import "Constants.h"

@interface EAObstacleTests : XCTestCase

@end

@implementation EAObstacleTests

#pragma mark - obstacleWithImageNamed:

- (void)testObstacleCreationWithValidImage
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    XCTAssertNotNil(obstacle);
    XCTAssertTrue([obstacle isKindOfClass:[EAObstacle class]]);
}

- (void)testObstacleCreationWithEveryGameObstacleImage
{
    NSArray *imageNames = @[@"UFO_top_pipe", @"UFO_down_pipe", @"AsteroidTop", @"AsteroidDown"];

    for (NSString *name in imageNames) {
        EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:name];
        XCTAssertNotNil(obstacle, @"Failed to create obstacle for image %@", name);
        XCTAssertGreaterThan(obstacle.size.width, 0.0f, @"Obstacle %@ has no texture size", name);
        XCTAssertGreaterThan(obstacle.size.height, 0.0f, @"Obstacle %@ has no texture size", name);
    }
}

- (void)testObstacleCreationWithNilNameThrows
{
    NSString *name = nil;
    XCTAssertThrows([EAObstacle obstacleWithImageNamed:name]);
}

- (void)testObstacleCreationWithEmptyNameThrows
{
    XCTAssertThrows([EAObstacle obstacleWithImageNamed:@""]);
}

- (void)testObstacleCreationWithBlankNameThrows
{
    XCTAssertThrows([EAObstacle obstacleWithImageNamed:@" "]);
}

#pragma mark - moveObstacleWithScale:

- (void)testMoveObstacleConfiguresPhysicsBody
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    [obstacle moveObstacleWithScale:2.0f];

    XCTAssertNotNil(obstacle.physicsBody);
    XCTAssertFalse(obstacle.physicsBody.affectedByGravity);
    XCTAssertFalse(obstacle.physicsBody.dynamic);
    XCTAssertEqual(obstacle.physicsBody.categoryBitMask, kPipeCategory);
    XCTAssertEqual(obstacle.physicsBody.collisionBitMask, kHeroCategory);
}

- (void)testMoveObstacleAppliesVerticalScale
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    [obstacle moveObstacleWithScale:3.5f];

    XCTAssertEqualWithAccuracy(obstacle.yScale, 3.5f, 0.001f);
}

- (void)testMoveObstacleSetsStretchableCenterRect
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    [obstacle moveObstacleWithScale:1.0f];

    XCTAssertEqualWithAccuracy(obstacle.centerRect.origin.x, 26.0f / kPipeWidth, 0.001f);
    XCTAssertEqualWithAccuracy(obstacle.centerRect.origin.y, 26.0f / kPipeWidth, 0.001f);
    XCTAssertEqualWithAccuracy(obstacle.centerRect.size.width, 4.0f / kPipeWidth, 0.001f);
    XCTAssertEqualWithAccuracy(obstacle.centerRect.size.height, 4.0f / kPipeWidth, 0.001f);
}

- (void)testMoveObstacleStartsMovementAction
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    [obstacle moveObstacleWithScale:1.0f];

    XCTAssertTrue(obstacle.hasActions);
}

- (void)testMoveObstacleWithZeroScaleThrows
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    XCTAssertThrows([obstacle moveObstacleWithScale:0.0f]);
}

- (void)testMoveObstacleWithNegativeScaleThrows
{
    EAObstacle *obstacle = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];

    XCTAssertThrows([obstacle moveObstacleWithScale:-1.0f]);
}

@end
