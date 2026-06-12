//
//  EAGameViewController.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAGameViewController.h"
#import "EAMenuScene.h"


@interface EAGameViewController () 

@property (nonatomic, strong) SKView *skView;

@end


@implementation EAGameViewController;

#pragma mark - Life cycle

/**
 * Creates SKView as the main view for SpriteKit rendering.
 * Uses full screen bounds for optimal display.
 * Caps rendering at 60 fps - the gameplay gains nothing from 120 Hz
 * ProMotion rates and the cap halves GPU and battery cost there.
 */
- (void)loadView
{
    self.view = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.skView = (SKView *)self.view;
    self.skView.preferredFramesPerSecond = 60;
}

/**
 * Presents the menu scene as the initial screen.
 * Sets aspect fill scale mode for proper screen fitting.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKScene *scene = [EAMenuScene sceneWithSize:self.skView.bounds.size];
    [scene setScaleMode:SKSceneScaleModeAspectFill];
    
    [self.skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIViewController overriden API

/**
 * Hides status bar for immersive fullscreen gameplay.
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
