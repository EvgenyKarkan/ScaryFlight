//
//  EAAppDelegate.h
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAGameViewController.h"

/**
 * Application delegate responsible for app lifecycle management.
 * Handles initial setup including window creation, GameViewController initialization,
 * and Game Center authentication at launch.
 */
@interface EAAppDelegate : UIResponder <UIApplicationDelegate>

/// Main application window
@property (nonatomic, strong) UIWindow *window;

/// Game view controller that hosts the SpriteKit scene
@property (nonatomic, strong) EAGameViewController *gameViewController;

@end
