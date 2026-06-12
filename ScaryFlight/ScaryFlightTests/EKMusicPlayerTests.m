//
//  EKMusicPlayerTests.m
//  ScaryFlightTests
//
//  Copyright (c) 2026 EvgenyKarkan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EKMusicPlayer.h"

@interface EKMusicPlayerTests : XCTestCase

@end

@implementation EKMusicPlayerTests

- (void)tearDown
{
    [[EKMusicPlayer sharedInstance] stop];
    [super tearDown];
}

#pragma mark - Singleton contract

- (void)testSharedInstanceIsNotNil
{
    XCTAssertNotNil([EKMusicPlayer sharedInstance]);
}

- (void)testSharedInstanceReturnsSameObject
{
    XCTAssertEqual([EKMusicPlayer sharedInstance], [EKMusicPlayer sharedInstance]);
}

- (void)testAllocReturnsSharedInstance
{
    XCTAssertEqual([[EKMusicPlayer alloc] init], [EKMusicPlayer sharedInstance]);
}

- (void)testCopyReturnsSharedInstance
{
    EKMusicPlayer *player = [EKMusicPlayer sharedInstance];
    XCTAssertEqual([player copy], player);
}

- (void)testNewThrows
{
    XCTAssertThrows([EKMusicPlayer new]);
}

#pragma mark - Playback from main bundle

- (void)testPlayMusicFileFromMainBundleLoadsTrack
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];

    XCTAssertGreaterThan([[EKMusicPlayer sharedInstance] duration], 0.0);
}

- (void)testPlayMusicFileFromMainBundleWithNilNameThrows
{
    NSString *fileName = nil;
    XCTAssertThrows([[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:fileName]);
}

- (void)testPlayMusicFileFromMainBundleWithEmptyNameThrows
{
    XCTAssertThrows([[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@""]);
}

- (void)testPlayMusicFileFromMainBundleWithMissingFileThrows
{
    XCTAssertThrows([[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"NoSuchFile.mp3"]);
}

- (void)testRepeatedPlaybackReusesCachedPlayer
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    id firstPlayer = [[EKMusicPlayer sharedInstance] valueForKey:@"player"];

    [[EKMusicPlayer sharedInstance] stop];
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    id secondPlayer = [[EKMusicPlayer sharedInstance] valueForKey:@"player"];

    XCTAssertEqual(firstPlayer, secondPlayer, @"The same track must reuse its cached AVAudioPlayer");
}

- (void)testSwitchingTracksStopsThePreviousTrack
{
    // Regression: cached players stay alive, so the menu music must
    // explicitly silence the still-looping game track and vice versa
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"CityFlightSound.mp3"];
    AVAudioPlayer *gamePlayer = [[EKMusicPlayer sharedInstance] valueForKey:@"player"];
    XCTAssertTrue(gamePlayer.isPlaying);

    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    AVAudioPlayer *menuPlayer = [[EKMusicPlayer sharedInstance] valueForKey:@"player"];

    XCTAssertFalse(gamePlayer.isPlaying, @"The previous track must stop when a new one starts");
    XCTAssertTrue(menuPlayer.isPlaying);
}

- (void)testSwitchingToDataPlaybackStopsThePreviousTrack
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"CityFlightSound.mp3"];
    AVAudioPlayer *gamePlayer = [[EKMusicPlayer sharedInstance] valueForKey:@"player"];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuSound" ofType:@"mp3"];
    [[EKMusicPlayer sharedInstance] playMusicFile:[NSData dataWithContentsOfFile:path]];

    XCTAssertFalse(gamePlayer.isPlaying, @"The previous track must stop when data playback starts");
}

- (void)testPlaybackRestartsFromBeginningWhenTrackIsReplayed
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];
    [[EKMusicPlayer sharedInstance] pause];

    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];

    XCTAssertLessThan([[EKMusicPlayer sharedInstance] currentTime], 0.5);
}

#pragma mark - Playback from data

- (void)testPlayMusicFileFromDataLoadsTrack
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuSound" ofType:@"mp3"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    XCTAssertNotNil(data);

    [[EKMusicPlayer sharedInstance] playMusicFile:data];

    XCTAssertGreaterThan([[EKMusicPlayer sharedInstance] duration], 0.0);
}

- (void)testPlayMusicFileWithNilDataThrows
{
    NSData *data = nil;
    XCTAssertThrows([[EKMusicPlayer sharedInstance] playMusicFile:data]);
}

#pragma mark - Playback control

- (void)testStopResetsCurrentTimeToZero
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];

    [[EKMusicPlayer sharedInstance] stop];

    XCTAssertEqualWithAccuracy([[EKMusicPlayer sharedInstance] currentTime], 0.0, 0.001);
}

- (void)testPauseAndResumeDoNotThrow
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];

    XCTAssertNoThrow([[EKMusicPlayer sharedInstance] pause]);
    XCTAssertNoThrow([[EKMusicPlayer sharedInstance] play]);
}

- (void)testSetupNumberOfLoopsIsAppliedToUnderlyingPlayer
{
    [[EKMusicPlayer sharedInstance] playMusicFileFromMainBundle:@"MenuSound.mp3"];

    [[EKMusicPlayer sharedInstance] setupNumberOfLoops:-1];

    NSNumber *loops = [[EKMusicPlayer sharedInstance] valueForKeyPath:@"player.numberOfLoops"];
    XCTAssertEqual([loops integerValue], (NSInteger)-1);
}

- (void)testControlMethodsAreSafeWithoutLoadedTrack
{
    // Force a fresh state: nothing guarantees a track is loaded yet
    XCTAssertNoThrow([[EKMusicPlayer sharedInstance] pause]);
    XCTAssertNoThrow([[EKMusicPlayer sharedInstance] stop]);
    XCTAssertNoThrow([[EKMusicPlayer sharedInstance] setupNumberOfLoops:0]);
}

@end
