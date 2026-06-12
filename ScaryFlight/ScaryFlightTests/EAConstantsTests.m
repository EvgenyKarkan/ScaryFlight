//
//  EAConstantsTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Constants.h"

@interface EAConstantsTests : XCTestCase

@end

@implementation EAConstantsTests

#pragma mark - Physics category bit masks

- (void)testCategoryBitMasksAreSingleBits
{
    XCTAssertEqual(kHeroCategory,   (uint32_t)(0x1 << 0));
    XCTAssertEqual(kPipeCategory,   (uint32_t)(0x1 << 1));
    XCTAssertEqual(kGroundCategory, (uint32_t)(0x1 << 2));
}

- (void)testCategoryBitMasksDoNotOverlap
{
    XCTAssertEqual(kHeroCategory & kPipeCategory,   (uint32_t)0);
    XCTAssertEqual(kHeroCategory & kGroundCategory, (uint32_t)0);
    XCTAssertEqual(kPipeCategory & kGroundCategory, (uint32_t)0);
}

#pragma mark - Gameplay constants

- (void)testGameplayConstantsArePositive
{
    XCTAssertGreaterThan(kDensity,       0.0f);
    XCTAssertGreaterThan(kPipeSpeed,     0.0f);
    XCTAssertGreaterThan(kPipeWidth,     0.0f);
    XCTAssertGreaterThan(kPipeGap,       0.0f);
    XCTAssertGreaterThan(kPipeFrequency, 0.0f);
    XCTAssertGreaterThan(kGroundHeight,  0.0f);
}

- (void)testPipeGapIsLargerThanGroundHeight
{
    // The gap the hero flies through must not be swallowed by the ground band
    XCTAssertGreaterThan(kPipeGap, kGroundHeight);
}

- (void)testPipeFrequencyAllowsPipeToTravelAcrossScreen
{
    // A new pipe spawns every kPipeFrequency seconds while a pipe needs
    // kPipeSpeed seconds to cross the screen - both must stay in sane bounds
    XCTAssertLessThanOrEqual(kPipeFrequency, kPipeSpeed);
}

@end
