//
//  EAGameScenesTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EABaseGameScene.h"
#import "EAUFOGameScene.h"
#import "EARocketGameScene.h"
#import "EKMusicPlayer.h"
#import "Constants.h"

/**
 * Exposes the private theming hooks of EABaseGameScene for verification.
 * The methods already exist in the class - this category only re-declares them.
 */
@interface EABaseGameScene (TestingHooks)

- (NSString *)heroImageStateOne;
- (NSString *)heroImageStateTwo;
- (NSString *)topObstacleImage;
- (NSString *)bottomObstacleImage;
- (NSString *)backgroundImageName;

@end


@interface EAGameScenesTests : XCTestCase

@property (nonatomic, strong) SKView *view;

@end

@implementation EAGameScenesTests

- (void)setUp
{
    [super setUp];
    self.view = [[SKView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 568.0f)];
}

- (void)tearDown
{
    // Stop the obstacle spawn timer the scene schedules in didMoveToView
    SKScene *scene = self.view.scene;
    if ([scene isKindOfClass:[EABaseGameScene class]]) {
        [[scene valueForKey:@"obstacleTimer"] invalidate];
    }

    [self.view presentScene:nil];
    self.view = nil;
    [[EKMusicPlayer sharedInstance] stop];

    [super tearDown];
}

#pragma mark - Helpers

- (EAUFOGameScene *)presentedUFOScene
{
    EAUFOGameScene *scene = [[EAUFOGameScene alloc] initWithSize:CGSizeMake(320.0f, 568.0f)];
    [self.view presentScene:scene];
    return scene;
}

- (EARocketGameScene *)presentedRocketScene
{
    EARocketGameScene *scene = [[EARocketGameScene alloc] initWithSize:CGSizeMake(320.0f, 568.0f)];
    [self.view presentScene:scene];
    return scene;
}

- (SKNode *)groundNodeInScene:(SKScene *)scene
{
    for (SKNode *child in scene.children) {
        if (child.physicsBody.categoryBitMask == kGroundCategory) {
            return child;
        }
    }
    return nil;
}

#pragma mark - Theming hooks

- (void)testBaseSceneThemingHooksReturnNil
{
    EABaseGameScene *scene = [[EABaseGameScene alloc] initWithSize:CGSizeMake(320.0f, 568.0f)];

    XCTAssertNil([scene heroImageStateOne]);
    XCTAssertNil([scene heroImageStateTwo]);
    XCTAssertNil([scene topObstacleImage]);
    XCTAssertNil([scene bottomObstacleImage]);
    XCTAssertNil([scene backgroundImageName]);
}

- (void)testUFOSceneProvidesUFOAssets
{
    EAUFOGameScene *scene = [[EAUFOGameScene alloc] initWithSize:CGSizeMake(320.0f, 568.0f)];

    XCTAssertEqualObjects([scene heroImageStateOne],   @"UFO_new_hero");
    XCTAssertEqualObjects([scene heroImageStateTwo],   @"UFO_new_hero2");
    XCTAssertEqualObjects([scene topObstacleImage],    @"UFO_top_pipe");
    XCTAssertEqualObjects([scene bottomObstacleImage], @"UFO_down_pipe");
    XCTAssertEqualObjects([scene backgroundImageName], @"City");
}

- (void)testRocketSceneProvidesRocketAssets
{
    EARocketGameScene *scene = [[EARocketGameScene alloc] initWithSize:CGSizeMake(320.0f, 568.0f)];

    XCTAssertEqualObjects([scene heroImageStateOne],   @"Rocket");
    XCTAssertEqualObjects([scene heroImageStateTwo],   @"Rocket2");
    XCTAssertEqualObjects([scene topObstacleImage],    @"AsteroidTop");
    XCTAssertEqualObjects([scene bottomObstacleImage], @"AsteroidDown");
    XCTAssertEqualObjects([scene backgroundImageName], @"Space");
}

#pragma mark - Presented UFO scene

- (void)testPresentedUFOSceneCreatesHero
{
    EAUFOGameScene *scene = [self presentedUFOScene];

    XCTAssertNotNil(scene.hero);
    XCTAssertTrue([scene.hero isKindOfClass:[EAHero class]]);
    XCTAssertNotNil(scene.hero.parent, @"Hero must be added to the scene");
}

- (void)testPresentedUFOSceneConfiguresHeroPhysics
{
    EAUFOGameScene *scene = [self presentedUFOScene];

    XCTAssertNotNil(scene.hero.physicsBody);
    XCTAssertEqualWithAccuracy(scene.hero.physicsBody.density, kDensity, 0.001f);
    XCTAssertFalse(scene.hero.physicsBody.allowsRotation);
    XCTAssertEqual(scene.hero.physicsBody.categoryBitMask, kHeroCategory);
    XCTAssertEqual(scene.hero.physicsBody.contactTestBitMask, kPipeCategory | kGroundCategory);
    XCTAssertEqual(scene.hero.physicsBody.collisionBitMask, kGroundCategory | kPipeCategory);
}

- (void)testPresentedUFOSceneConfiguresPhysicsWorld
{
    EAUFOGameScene *scene = [self presentedUFOScene];

    XCTAssertEqualWithAccuracy(scene.physicsWorld.gravity.dx, 0.0f, 0.001f);
    XCTAssertEqualWithAccuracy(scene.physicsWorld.gravity.dy, -3.0f, 0.001f);
    XCTAssertEqual(scene.physicsWorld.contactDelegate, (id<SKPhysicsContactDelegate>)scene);
}

- (void)testPresentedUFOSceneAddsGround
{
    EAUFOGameScene *scene = [self presentedUFOScene];
    SKNode *ground = [self groundNodeInScene:scene];

    XCTAssertNotNil(ground);
    XCTAssertEqual(ground.physicsBody.collisionBitMask, kHeroCategory);
    XCTAssertFalse(ground.physicsBody.dynamic);
    XCTAssertFalse(ground.physicsBody.affectedByGravity);
}

- (void)testPresentedUFOSceneStartsObstacleTimer
{
    EAUFOGameScene *scene = [self presentedUFOScene];
    NSTimer *timer = [scene valueForKey:@"obstacleTimer"];

    XCTAssertNotNil(timer);
    XCTAssertTrue(timer.isValid);
    XCTAssertEqualWithAccuracy(timer.timeInterval, kPipeFrequency, 0.001);
}

- (void)testUFOSceneAddBottomPipeAddsOneObstacle
{
    EAUFOGameScene *scene = [self presentedUFOScene];
    NSUInteger obstaclesBefore = [self obstacleCountInScene:scene];

    [scene addBottomPipe:300.0f];

    XCTAssertEqual([self obstacleCountInScene:scene], obstaclesBefore + 1);
}

#pragma mark - Presented Rocket scene

- (void)testPresentedRocketSceneResizesHero
{
    EARocketGameScene *scene = [self presentedRocketScene];

    XCTAssertEqualWithAccuracy(scene.hero.size.width, 116.0f / 2.0f, 0.001f);
    XCTAssertEqualWithAccuracy(scene.hero.size.height, 91.0f / 2.0f, 0.001f);
}

- (void)testPresentedRocketSceneAddsGround
{
    EARocketGameScene *scene = [self presentedRocketScene];
    SKNode *ground = [self groundNodeInScene:scene];

    XCTAssertNotNil(ground);
    XCTAssertFalse(ground.physicsBody.dynamic);
}

- (void)testRocketSceneAddBottomPipeAddsTwoObstacles
{
    // Rocket mode stacks its own bottom asteroid on top of the base implementation
    EARocketGameScene *scene = [self presentedRocketScene];
    NSUInteger obstaclesBefore = [self obstacleCountInScene:scene];

    [scene addBottomPipe:300.0f];

    XCTAssertEqual([self obstacleCountInScene:scene], obstaclesBefore + 2);
}

#pragma mark - Counting helper

- (NSUInteger)obstacleCountInScene:(SKScene *)scene
{
    NSUInteger count = 0;
    for (SKNode *child in scene.children) {
        if ([child isKindOfClass:[EAObstacle class]]) {
            count++;
        }
    }
    return count;
}

@end
