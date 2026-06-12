//
//  ScaryFlightTests.m
//  ScaryFlightTests
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAAppDelegate.h"
#import "EAGameViewController.h"
#import "EAMenuScene.h"

/**
 * Smoke tests covering the launched application stack.
 * The test bundle is injected into the running ScaryFlight app,
 * so the real app delegate, window and menu scene are available.
 */
@interface ScaryFlightTests : XCTestCase

@end

@implementation ScaryFlightTests

- (void)testAppDelegateIsCorrectClass
{
    XCTAssertTrue([[UIApplication sharedApplication].delegate isKindOfClass:[EAAppDelegate class]]);
}

- (void)testAppDelegateHasWindow
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;

    XCTAssertNotNil(delegate.window);
    XCTAssertTrue(delegate.window.isKeyWindow);
}

- (void)testRootViewControllerIsGameViewController
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;

    XCTAssertNotNil(delegate.gameViewController);
    XCTAssertEqual(delegate.window.rootViewController, delegate.gameViewController);
}

- (void)testGameViewControllerUsesSpriteKitView
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;

    XCTAssertTrue([delegate.gameViewController.view isKindOfClass:[SKView class]]);
}

- (void)testMenuSceneIsPresentedAtLaunch
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;
    SKView *skView = (SKView *)delegate.gameViewController.view;

    XCTAssertTrue([skView.scene isKindOfClass:[EAMenuScene class]]);
}

- (void)testSpriteKitViewCapsFrameRate
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;
    SKView *skView = (SKView *)delegate.gameViewController.view;

    XCTAssertEqual(skView.preferredFramesPerSecond, 60);
}

- (void)testGameViewControllerHidesStatusBar
{
    EAAppDelegate *delegate = (EAAppDelegate *)[UIApplication sharedApplication].delegate;

    XCTAssertTrue([delegate.gameViewController prefersStatusBarHidden]);
}

@end
