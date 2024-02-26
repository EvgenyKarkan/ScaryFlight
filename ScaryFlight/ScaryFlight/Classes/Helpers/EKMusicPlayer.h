//
//  EKMusicPlayer.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 02.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//


@interface EKMusicPlayer : NSObject

+ (EKMusicPlayer *)sharedInstance;
- (void)playMusicFile:(NSData *)file;
- (void)playMusicFileFromMainBundle:(NSString *)fileNameWithExtension;
- (NSTimeInterval)currentTime;
- (NSTimeInterval)duration;
- (void)pause;
- (void)play;
- (void)stop;
- (void)setupNumberOfLoops:(NSInteger)loops;

@end
