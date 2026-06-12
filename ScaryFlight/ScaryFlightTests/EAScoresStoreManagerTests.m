//
//  EAScoresStoreManagerTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EAScoresStoreManager.h"

static NSString * const kTopScoreDefaultsKey = @"kTopScore";
static NSString * const kTestSuiteName       = @"com.evgenykarkan.scaryflight.tests";

@interface EAScoresStoreManagerTests : XCTestCase

@property (nonatomic, strong) NSUserDefaults *testDefaults;

@end

@implementation EAScoresStoreManagerTests

- (void)setUp
{
    [super setUp];

    // Isolated suite so tests never touch the app's real standardUserDefaults
    self.testDefaults = [[NSUserDefaults alloc] initWithSuiteName:kTestSuiteName];
    [self.testDefaults removePersistentDomainForName:kTestSuiteName];
    [EAScoresStoreManager setUserDefaults:self.testDefaults];
}

- (void)tearDown
{
    [EAScoresStoreManager setUserDefaults:nil];
    [self.testDefaults removePersistentDomainForName:kTestSuiteName];
    self.testDefaults = nil;

    [super tearDown];
}

#pragma mark - Backing store injection

- (void)testUserDefaultsFallsBackToStandardWhenNothingInjected
{
    [EAScoresStoreManager setUserDefaults:nil];

    XCTAssertEqual([EAScoresStoreManager userDefaults], [NSUserDefaults standardUserDefaults]);

    [EAScoresStoreManager setUserDefaults:self.testDefaults];
}

- (void)testInjectedUserDefaultsIsUsed
{
    XCTAssertEqual([EAScoresStoreManager userDefaults], self.testDefaults);
}

- (void)testWritesDoNotLeakIntoStandardUserDefaults
{
    id originalValue = [[NSUserDefaults standardUserDefaults] objectForKey:kTopScoreDefaultsKey];

    [EAScoresStoreManager setTopScore:12345];

    id valueAfterWrite = [[NSUserDefaults standardUserDefaults] objectForKey:kTopScoreDefaultsKey];
    XCTAssertEqualObjects(valueAfterWrite, originalValue,
                          @"Score writes must go to the injected suite, not the app's defaults");
}

#pragma mark - Store behaviour

- (void)testGetTopScoreReturnsZeroWhenNothingSaved
{
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)0);
}

- (void)testSetAndGetTopScoreRoundTrip
{
    [EAScoresStoreManager setTopScore:42];
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)42);
}

- (void)testSetTopScoreWithZero
{
    [EAScoresStoreManager setTopScore:0];
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)0);
}

- (void)testSetTopScoreOverwritesPreviousValue
{
    [EAScoresStoreManager setTopScore:10];
    [EAScoresStoreManager setTopScore:99];
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)99);
}

- (void)testSetTopScoreWithLargeValue
{
    [EAScoresStoreManager setTopScore:100000];
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)100000);
}

- (void)testTopScoreIsStoredAsStringUnderKnownKey
{
    [EAScoresStoreManager setTopScore:7];

    NSString *storedValue = [self.testDefaults stringForKey:kTopScoreDefaultsKey];
    XCTAssertEqualObjects(storedValue, @"7");
}

- (void)testLowerScoreStillOverwrites
{
    // The manager is a plain store - comparison logic lives in the scene
    [EAScoresStoreManager setTopScore:50];
    [EAScoresStoreManager setTopScore:3];
    XCTAssertEqual([EAScoresStoreManager getTopScore], (NSUInteger)3);
}

@end
