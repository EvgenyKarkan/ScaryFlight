//
//  EAGameCenterProviderTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAGameCenterProvider.h"

@interface EAGameCenterProviderTests : XCTestCase

@end

@implementation EAGameCenterProviderTests

#pragma mark - Singleton contract

- (void)testSharedInstanceIsNotNil
{
    XCTAssertNotNil([EAGameCenterProvider sharedInstance]);
}

- (void)testSharedInstanceReturnsSameObject
{
    XCTAssertEqual([EAGameCenterProvider sharedInstance], [EAGameCenterProvider sharedInstance]);
}

- (void)testAllocReturnsSharedInstance
{
    XCTAssertEqual([[EAGameCenterProvider alloc] init], [EAGameCenterProvider sharedInstance]);
}

- (void)testCopyReturnsSharedInstance
{
    EAGameCenterProvider *provider = [EAGameCenterProvider sharedInstance];
    XCTAssertEqual([provider copy], provider);
}

- (void)testNewThrows
{
    XCTAssertThrows([EAGameCenterProvider new]);
}

#pragma mark - userAuthenticated

- (void)testUserAuthenticatedIsReadWrite
{
    EAGameCenterProvider *provider = [EAGameCenterProvider sharedInstance];
    BOOL originalValue = provider.userAuthenticated;

    provider.userAuthenticated = YES;
    XCTAssertTrue(provider.userAuthenticated);

    provider.userAuthenticated = NO;
    XCTAssertFalse(provider.userAuthenticated);

    provider.userAuthenticated = originalValue;
}

#pragma mark - reportScore:

- (void)testReportScoreDoesNotThrowWhenUnauthenticated
{
    // Without an authenticated Game Center player this must be a safe no-op
    XCTAssertNoThrow([[EAGameCenterProvider sharedInstance] reportScore:10]);
}

- (void)testReportZeroScoreDoesNotThrow
{
    XCTAssertNoThrow([[EAGameCenterProvider sharedInstance] reportScore:0]);
}

@end
