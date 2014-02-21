//
//  EAGameCenterProvider.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 18.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//


@interface EAGameCenterProvider : NSObject 

@property (nonatomic, assign) BOOL userAuthenticated;

+ (EAGameCenterProvider *)sharedInstance;
- (void)authenticateLocalUser;
- (void)reportScore:(NSUInteger)score;
- (void)showLeaderboard;

@end
