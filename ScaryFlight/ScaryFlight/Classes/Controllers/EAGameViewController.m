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

- (void)loadView
{
    self.view  = [[SKView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    self.skView                = (SKView *)self.view;
    self.skView.showsFPS       = YES;
    self.skView.showsNodeCount = YES;
    self.skView.showsDrawCount = YES;
}

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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
