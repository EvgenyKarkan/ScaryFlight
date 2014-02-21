//
//  EABaseGameScene.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/15/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EABaseGameScene.h"
#import "EAMenuScene.h"
#import "Constants.h"
#import "EAScoresStoreManager.h"
#import "EAGameCenterProvider.h"

@interface EABaseGameScene () <SKPhysicsContactDelegate>

@property (nonatomic ,strong) SKLabelNode *topScoreLabel;
@property (nonatomic ,strong) SKLabelNode *scoresLabel;
@property (nonatomic ,strong) SKAction    *scoreSound;
@property (nonatomic ,strong) SKAction    *crashSound;
@property (nonatomic ,assign) NSUInteger   scores;
@property (nonatomic ,assign) NSUInteger   topScores;
@property (nonatomic, strong) NSTimer     *obstacleTimer;
@property (nonatomic ,strong) EAObstacle  *lastPipe;
@property (nonatomic ,strong) EAObstacle  *pipeTop;
@property (nonatomic ,strong) EAObstacle  *pipeBottom;

@end


@implementation EABaseGameScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -3.0f);
    self.physicsWorld.contactDelegate = self;
    
    [self addBackground];
    [self addHero];
    [self addScoring];
    [self addTopScore];
    [self makeObstaclesLoop];
    
    self.topScores = [EAScoresStoreManager getTopScore];
    
    self.scoreSound = [SKAction playSoundFileNamed:@"tick.mp3" waitForCompletion:NO];
    self.crashSound = [SKAction playSoundFileNamed:@"crash.wav" waitForCompletion:NO];
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    self.topScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.topScores];
    
    if (self.pipeTop.position.x > 0 && self.lastPipe != self.pipeTop) {
        if (self.hero.position.x > self.pipeTop.position.x) {
            self.scores++;
            
            if (self.topScores == 0) {  // only if it is first game start
                [[EAGameCenterProvider sharedInstance] reportScore:self.scores];
                NSLog(@"First game start");
            }
            
            if (self.scores > self.topScores && self.topScores > 0) {
                __weak typeof(self) weakSelf = self;
                
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [weakSelf runAction:[SKAction playSoundFileNamed:@"Bonus.wav" waitForCompletion:NO]];
                });
                [[EAGameCenterProvider sharedInstance] reportScore:self.scores];
            }
            self.scoresLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.scores];
            self.lastPipe = self.pipeTop;
            [self runAction:self.scoreSound];
        }
    }
}

#pragma mark - Setup sprites

- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:[self backgroundImageName]];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}

- (void)addHero
{
    self.hero = [EAHero spriteNodeWithImageNamed:@"UFO_new_hero"];
    self.hero.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    self.hero.position = CGPointMake(self.size.width / 2.25f, self.size.height / 2.25f);
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:[self heroImageStateOne]],
                                 [SKTexture textureWithImageNamed:[self heroImageStateTwo]]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.hero runAction:heroAction withKey:@"flyingHero"];
    [self addChild:self.hero];
    
    self.hero.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.hero.size];
    self.hero.physicsBody.density = kDensity;
    self.hero.physicsBody.allowsRotation = NO;
    self.hero.physicsBody.categoryBitMask = kHeroCategory;
    self.hero.physicsBody.contactTestBitMask = kPipeCategory | kGroundCategory;
    self.hero.physicsBody.collisionBitMask = kGroundCategory | kPipeCategory;
}

- (void)addScoring
{
    self.scoresLabel = [[SKLabelNode alloc] initWithFontNamed:@"PressStart2P"];
    self.scoresLabel.fontSize = 30.0f;
    self.scoresLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.scoresLabel.fontColor = [SKColor yellowColor];
    self.scoresLabel.position = CGPointMake(35.0f, self.size.height - 52.0f);
    self.scoresLabel.text = @"0";
    self.scoresLabel.zPosition = 1.0f;
    [self addChild:self.scoresLabel];
    
    self.scores = 0;
}

- (void)addTopScore
{
    self.topScoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"PressStart2P"];
    self.topScoreLabel.fontSize = 30.0f;
    self.topScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    self.topScoreLabel.fontColor = [SKColor cyanColor];
    self.topScoreLabel.position = CGPointMake(self.size.width - 50.0f, self.size.height - 52.0f);
    self.topScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.topScores];
    self.topScoreLabel.zPosition = 1.0f;
    [self addChild:self.topScoreLabel];
}

- (void)makeObstaclesLoop
{
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency
                                                          target:self
                                                        selector:@selector(addObstacle)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.obstacleTimer
                                 forMode:NSRunLoopCommonModes];
}

- (void)addObstacle
{
     // random game complexity. Changing hole position beetwen pipes
    CGFloat centerY = [EAUtils randomFloatWithMin:kPipeGap * 2.0f max:(self.size.height - kPipeGap * 2.0f)];
    
    [self addTopPipe:centerY];
    [self addBottomPipe:centerY];
}

- (void)addTopPipe:(float)centerY
{
    self.pipeTop = [EAObstacle obstacleWithImageNamed:[self topObstacleImage]];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    [self.pipeTop moveObstacleWithScale:pipeTopHeight / kPipeWidth];
    self.pipeTop.position = CGPointMake(self.size.width + (self.pipeTop.size.width / 2.0f), self.size.height - (self.pipeTop.size.height / 2.0f));
    [self addChild:self.pipeTop];
}

#pragma mark - Public APi

- (void)addBottomPipe:(float)centerY
{
    self.pipeBottom = [EAObstacle obstacleWithImageNamed:[self bottomObstacleImage]];
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [self.pipeBottom moveObstacleWithScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    self.pipeBottom.position = CGPointMake(self.size.width + (self.pipeBottom.size.width / 2.0f),
                                           (self.pipeBottom.size.height / 2.0f) + (kGroundHeight - 2.0f));
    [self addChild:self.pipeBottom];
}

#pragma mark - Helper API

- (void)gameOver
{
    SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:0.3f];
    EAMenuScene *newGame = [[EAMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newGame
                       transition:transition];
    [self topScoresUpdateIfNeed];
}

- (void)topScoresUpdateIfNeed
{
    if (self.scores > self.topScores) {
        self.topScores = self.scores;
        [EAScoresStoreManager setTopScore:self.topScores];
    }
}

#pragma mark - UIResponder overriden API

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self.hero flyWithYLimit:self.size.height];
    }
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *node = contact.bodyA.node;
    __weak typeof(self) weakSelf = self;
    
    if ([node isKindOfClass:[EAHero class]]) {
        [self.obstacleTimer invalidate];
        [self runAction:self.crashSound
             completion: ^{
                 [weakSelf gameOver];
             }];
    }
}

#pragma mark - Private API

- (NSString *)heroImageStateOne
{
    return nil;
}

- (NSString *)heroImageStateTwo
{
    return nil;
}

- (NSString *)topObstacleImage
{
    return nil;
}

- (NSString *)bottomObstacleImage
{
    return nil;
}

- (NSString *)backgroundImageName
{
    return nil;
}

@end
