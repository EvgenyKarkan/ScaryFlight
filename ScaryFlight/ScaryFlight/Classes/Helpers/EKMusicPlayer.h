//
//  EKMusicPlayer.h
//  JustApp
//
//  Created by Evgeny Karkan on 02.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

/**
 * Singleton audio player for background music and sound effects.
 * Caches one AVAudioPlayer per bundle track, so each file is read from
 * disk and prepared only once for the lifetime of the app.
 * Starting a track stops the one currently playing.
 * Provides playback control: play, pause, stop, and loop configuration.
 */
@interface EKMusicPlayer : NSObject

/// Shared singleton instance
+ (EKMusicPlayer *)sharedInstance;

/**
 * Plays music from NSData, stopping the currently playing track.
 * Data-based players are not cached.
 * @param file Audio data to play
 */
- (void)playMusicFile:(NSData *)file;

/**
 * Plays music file from main bundle, stopping the currently playing track.
 * The player is cached per file name; playback always restarts from
 * the beginning of the track.
 * @param fileNameWithExtension File name with extension (e.g., @"MenuSound.mp3")
 */
- (void)playMusicFileFromMainBundle:(NSString *)fileNameWithExtension;

/// Current playback time in seconds
- (NSTimeInterval)currentTime;

/// Total duration in seconds
- (NSTimeInterval)duration;

/// Pauses playback
- (void)pause;

/// Resumes playback
- (void)play;

/// Stops playback and resets time to zero
- (void)stop;

/// Sets number of times to loop playback (0 = no loop, -1 = infinite)
- (void)setupNumberOfLoops:(NSInteger)loops;

@end
