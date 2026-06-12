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

/// Action key for the obstacle spawn loop so it can be stopped on game over
static NSString * const kEAObstacleSpawnActionKey = @"obstacleSpawnLoop";


@interface EABaseGameScene () <SKPhysicsContactDelegate>

@property (nonatomic ,strong) SKLabelNode *topScoreLabel;
@property (nonatomic ,strong) SKLabelNode *scoresLabel;
@property (nonatomic ,strong) SKAction    *scoreSound;
@property (nonatomic ,strong) SKAction    *crashSound;
@property (nonatomic ,strong) SKAction    *bonusSound;
@property (nonatomic ,assign) NSUInteger   scores;
@property (nonatomic ,assign) NSUInteger   topScores;
@property (nonatomic ,strong) EAObstacle  *lastPipe;
@property (nonatomic ,strong) EAObstacle  *pipeTop;
@property (nonatomic ,strong) EAObstacle  *pipeBottom;
@property (nonatomic ,assign) BOOL         topScoreBeated;
@property (nonatomic ,assign) BOOL         gameEnded;

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
    self.topScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.topScores];
    
    self.scoreSound = [SKAction playSoundFileNamed:@"tick.mp3" waitForCompletion:NO];
    self.crashSound = [SKAction playSoundFileNamed:@"crash.wav" waitForCompletion:NO];
    self.bonusSound = [SKAction playSoundFileNamed:@"Bonus.wav" waitForCompletion:NO];
    
    self.topScoreBeated = NO;
    self.gameEnded = NO;
}

/**
 * Increments score when hero passes through obstacle gap.
 * Reports score to Game Center when new top score achieved.
 * Returns early while no scorable pipe exists or after the game ended,
 * keeping the per-frame cost of this callback minimal.
 */
- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];

    if (self.gameEnded || self.pipeTop == nil || self.lastPipe == self.pipeTop) {
        return;
    }

    if (self.pipeTop.position.x > 0 && self.hero.position.x > self.pipeTop.position.x) {
        self.scores++;

        if (self.topScores == 0) {  // only if it is first game start
            [[EAGameCenterProvider sharedInstance] reportScore:self.scores];
        }

        if (self.scores > self.topScores && self.topScores > 0) {
            [[EAGameCenterProvider sharedInstance] reportScore:self.scores];
        }

        self.scoresLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.scores];
        self.lastPipe = self.pipeTop;
        [self runAction:self.scoreSound];
    }
}

#pragma mark - Setup sprites

/**
 * Creates and positions the background sprite using the subclass-provided image name.
 * @see backgroundImageName - subclass method to override
 */
- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:[self backgroundImageName]];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}

/**
 * Creates and configures the hero sprite with animated textures.
 * Sets up physics body with density and collision bitmasks from Constants.h.
 */
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
    // kDensity affects how heavy the hero feels - higher = harder to maneuver
    self.hero.physicsBody.density = kDensity;
    self.hero.physicsBody.allowsRotation = NO;
    // Physics category bitmasks control collision detection behavior
    self.hero.physicsBody.categoryBitMask = kHeroCategory;
    self.hero.physicsBody.contactTestBitMask = kPipeCategory | kGroundCategory;
    self.hero.physicsBody.collisionBitMask = kGroundCategory | kPipeCategory;
}

/**
 * Creates and positions the score label at top-left of screen.
 * Initializes current score to 0.
 */
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

/**
 * Creates and positions the top score label at top-right of screen.
 * Displays the highest score from persistent storage.
 */
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

/**
 * Spawns obstacles at regular intervals driven by a scene action.
 * Creates both top and bottom pipe pairs with random gap positioning.
 * Scene actions stop and are released together with the scene, so the
 * spawn loop cannot outlive or retain the scene (unlike an NSTimer).
 */
- (void)makeObstaclesLoop
{
    __weak typeof(self) weakSelf = self;

    SKAction *wait = [SKAction waitForDuration:kPipeFrequency];
    SKAction *spawn = [SKAction runBlock: ^{
        [weakSelf addObstacle];
    }];

    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[wait, spawn]]]
            withKey:kEAObstacleSpawnActionKey];
}

/**
 * Creates a pair of top and bottom obstacles at the specified center Y position.
 * The gap between them is determined by kPipeGap constant.
 * Top/bottom image names are provided by subclass implementations.
 */
- (void)addObstacle
{
     // random game complexity. Changing hole position beetwen pipes
    CGFloat delta = 2.0f;
    CGFloat centerY = (CGFloat)[EAUtils randomFloatWithMin:kPipeGap * delta max:(self.size.height - kPipeGap * delta)];
    
    [self addTopPipe:centerY];
    [self addBottomPipe:centerY];
}

/**
 * Creates top obstacle at calculated position based on centerY.
 * Uses subclass-provided image name for themed appearance.
 */
- (void)addTopPipe:(CGFloat)centerY
{
    self.pipeTop = [EAObstacle obstacleWithImageNamed:[self topObstacleImage]];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    [self.pipeTop moveObstacleWithScale:pipeTopHeight / kPipeWidth];
    self.pipeTop.position = CGPointMake(self.size.width + (self.pipeTop.size.width / 2.0f), self.size.height - (self.pipeTop.size.height / 2.0f));
    [self addChild:self.pipeTop];
}

#pragma mark - Public API

- (void)addBottomPipe:(CGFloat)centerY
{
    self.pipeBottom = [EAObstacle obstacleWithImageNamed:[self bottomObstacleImage]];
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [self.pipeBottom moveObstacleWithScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    self.pipeBottom.position = CGPointMake(self.size.width + (self.pipeBottom.size.width / 2.0f),
                                           (self.pipeBottom.size.height / 2.0f) + (kGroundHeight - 2.0f));
    [self addChild:self.pipeBottom];
}

#pragma mark - Helper API

/**
 * Transitions back to menu scene with horizontal door transition.
 * Updates top score in persistent storage if current score is higher.
 */
- (void)gameOver
{
    SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:0.3f];
    EAMenuScene *newGame = [[EAMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newGame
                       transition:transition];
    [self topScoresUpdateIfNeed];
}

/**
 * Updates top score in NSUserDefaults if current score exceeds it.
 * Called automatically when game ends.
 */
- (void)topScoresUpdateIfNeed
{
    if (self.scores > self.topScores) {
        self.topScores = self.scores;
        [EAScoresStoreManager setTopScore:self.topScores];
    }
}

#pragma mark - UIResponder overriden API

/**
 * Handles touch events - triggers hero flight upward.
 * Each touch applies an upward impulse to the hero.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (touch != nil) {
            [self.hero flyWithYLimit:self.size.height];
        }
    }
}

#pragma mark - SKPhysicsContactDelegate

/**
 * Handles collision detection between hero and obstacles/ground.
 * The hero may arrive as either body of the contact, and a single crash
 * usually produces several contacts - the game over path must run once.
 * Stops obstacle spawning, plays crash sound, then transitions to game over.
 */
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (self.gameEnded) {
        return;
    }

    BOOL heroInvolved = [contact.bodyA.node isKindOfClass:[EAHero class]] ||
                        [contact.bodyB.node isKindOfClass:[EAHero class]];

    if (heroInvolved) {
        self.gameEnded = YES;
        [self removeActionForKey:kEAObstacleSpawnActionKey];

        __weak typeof(self) weakSelf = self;
        [self runAction:self.crashSound
             completion: ^{
                 [weakSelf gameOver];
             }];
    }
}

#pragma mark - Private API to override in subclasses

/**
 * @return Image name for hero animation frame one
 */
- (NSString *)heroImageStateOne
{
    return nil;
}

/**
 * @return Image name for hero animation frame two
 */
- (NSString *)heroImageStateTwo
{
    return nil;
}

/**
 * @return Image name for top pipe/asteroid sprite
 */
- (NSString *)topObstacleImage
{
    return nil;
}

/**
 * @return Image name for bottom pipe/asteroid sprite
 */
- (NSString *)bottomObstacleImage
{
    return nil;
}

/**
 * @return Image name for scene background
 */
- (NSString *)backgroundImageName
{
    return nil;
}

#pragma mark - self.scores setter

/**
 * Custom setter that plays bonus sound when top score is beaten.
 * Prevents repeated bonus sound via topScoreBeated flag.
 */
- (void)setScores:(NSUInteger)scores
{
    NSParameterAssert(scores >= 0);
    
    if (_scores != scores) {
        _scores = scores;
        if (self.topScoreBeated == NO) {
            if (_scores > self.topScores && self.topScores > 0) {
                [self runAction:self.bonusSound];
                self.topScoreBeated = !self.topScoreBeated;
            }
        }
    }
}

@end
