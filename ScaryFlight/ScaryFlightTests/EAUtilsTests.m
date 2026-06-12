//
//  EAUtilsTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAUtils.h"

@interface EAUtilsTests : XCTestCase

@end

@implementation EAUtilsTests

#pragma mark - randomFloatWithMin:max:

- (void)testRandomFloatStaysWithinPositiveRange
{
    for (NSUInteger i = 0; i < 1000; i++) {
        float value = [EAUtils randomFloatWithMin:10.0f max:20.0f];
        XCTAssertGreaterThanOrEqual(value, 10.0f);
        XCTAssertLessThanOrEqual(value, 20.0f);
    }
}

- (void)testRandomFloatStaysWithinNegativeRange
{
    for (NSUInteger i = 0; i < 1000; i++) {
        float value = [EAUtils randomFloatWithMin:-50.0f max:-10.0f];
        XCTAssertGreaterThanOrEqual(value, -50.0f);
        XCTAssertLessThanOrEqual(value, -10.0f);
    }
}

- (void)testRandomFloatStaysWithinRangeCrossingZero
{
    for (NSUInteger i = 0; i < 1000; i++) {
        float value = [EAUtils randomFloatWithMin:-5.0f max:5.0f];
        XCTAssertGreaterThanOrEqual(value, -5.0f);
        XCTAssertLessThanOrEqual(value, 5.0f);
    }
}

- (void)testRandomFloatWithEqualIntegralBoundsReturnsBound
{
    for (NSUInteger i = 0; i < 100; i++) {
        float value = [EAUtils randomFloatWithMin:7.0f max:7.0f];
        XCTAssertEqualWithAccuracy(value, 7.0f, 0.0001f);
    }
}

- (void)testRandomFloatReturnsIntegralValues
{
    // Implementation floors the result, so values must be whole numbers
    for (NSUInteger i = 0; i < 100; i++) {
        float value = [EAUtils randomFloatWithMin:0.0f max:100.0f];
        XCTAssertEqualWithAccuracy(value, floorf(value), 0.0001f);
    }
}

- (void)testRandomFloatProducesVariedValues
{
    NSMutableSet *seenValues = [NSMutableSet set];

    for (NSUInteger i = 0; i < 1000; i++) {
        float value = [EAUtils randomFloatWithMin:0.0f max:1000.0f];
        [seenValues addObject:@(value)];
    }

    XCTAssertGreaterThan(seenValues.count, 1, @"Generator should produce more than one distinct value");
}

#pragma mark - OS version checks

- (void)testOSVersionChecksAreMutuallyExclusiveAndExhaustive
{
    BOOL lessThan71 = [EAUtils isLessThanIOS_7_1];
    BOOL greaterOrEqual71 = [EAUtils isGreaterThanOrEqualToIOS_7_1];

    XCTAssertNotEqual(lessThan71, greaterOrEqual71, @"Exactly one of the version checks must be true");
}

- (void)testModernRuntimeIsGreaterThanOrEqualToIOS_7_1
{
    // The test host requires a deployment target far beyond 7.1
    XCTAssertTrue([EAUtils isGreaterThanOrEqualToIOS_7_1]);
    XCTAssertFalse([EAUtils isLessThanIOS_7_1]);
}

#pragma mark - Device checks

- (void)testIsIPhone5MatchesScreenHeight
{
    BOOL expected = (fabs((double)[[UIScreen mainScreen] bounds].size.height - 568.0) < DBL_EPSILON);
    XCTAssertEqual([EAUtils isIPhone5], expected);
}

#pragma mark - assetName

- (void)testAssetNameIsKnownValue
{
    NSArray *knownAssets = @[@"iPhone4", @"iPhone5"];
    XCTAssertTrue([knownAssets containsObject:[EAUtils assetName]]);
}

- (void)testAssetNameIsConsistentWithDeviceCheck
{
    NSString *expected = [EAUtils isIPhone5] ? @"iPhone5" : @"iPhone4";
    XCTAssertEqualObjects([EAUtils assetName], expected);
}

@end
