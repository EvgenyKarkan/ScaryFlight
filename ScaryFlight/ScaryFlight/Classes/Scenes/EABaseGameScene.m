//
//  EABaseGameScene.m
//  ScaryFlight
//
//  Created by Artem Kislitsyn on 2/15/14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EABaseGameScene.h"
#import "EAUFOGameScene.h"
#import "EAHero.h"
#import "EAObstacle.h"
#import "EAMenuScene.h"


static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;

static CGFloat const kDensity       = 2.0f;
static CGFloat const kPipeSpeed     = 4.5f;
static CGFloat const kPipeWidth     = 56.0f;
static CGFloat const kPipeGap       = 80.0f;
static CGFloat const kPipeFrequency = 2.5f;
static CGFloat const kGroundHeight  = 6.0f;


@interface EABaseGameScene () <SKPhysicsContactDelegate>




//@property (nonatomic, strong) EAHero *hero;
//@property (nonatomic ,strong) SKLabelNode * scoresLabel;
//@property (nonatomic ,assign) NSUInteger  scores;
//@property (nonatomic ,strong) EAObstacle *pipeTop;
//@property (nonatomic ,strong) EAObstacle *lastPipe;
//@property (nonatomic, strong) NSTimer *obstacleTimer;


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
    [self makeObstaclesLoop];
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
    [self.hero setPosition:CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f)];
    
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
    self.scoresLabel.fontColor = [SKColor yellowColor];
    self.scoresLabel.position = CGPointMake(25.0f, self.size.height - 42.0f);
    self.scoresLabel.text = @"0";
    self.scoresLabel.zPosition = 1.0f;
    [self addChild:self.scoresLabel];
    
    self.scores = 0;
}

- (void)addObstacle
{
    CGFloat centerY = [self randomFloatWithMin:kPipeGap * 1.5f max:(self.size.height - kPipeGap * 1.5f)];
    
    self.pipeTop = [EAObstacle obstacleWithImageNamed:[self topObstacleImage]];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    [self.pipeTop moveObstacleWithScale:pipeTopHeight / kPipeWidth];
    self.pipeTop.position = CGPointMake(self.size.width + (self.pipeTop.size.width / 2.0f), self.size.height - (self.pipeTop.size.height / 2.0f));
    [self addChild:self.pipeTop];
    
    EAObstacle *pipeBottom = [EAObstacle obstacleWithImageNamed:[self bottomObstacleImage]];
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [pipeBottom moveObstacleWithScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    pipeBottom.position = CGPointMake(self.size.width + (pipeBottom.size.width / 2.0f), (pipeBottom.size.height / 2.0f) + (kGroundHeight - 2.0f));
    [self addChild:pipeBottom];
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

#pragma mark - Helper API

- (CGFloat)randomFloatWithMin:(CGFloat)min max:(CGFloat)max
{
    return floor(((rand() % RAND_MAX) / (RAND_MAX * 1.0)) * (max - min) + min);
}

#pragma mark - UIResponder overriden API

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self.hero fly];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    [super update:currentTime];
    
    if (self.pipeTop.position.x > 0 && self.lastPipe != self.pipeTop) {
        if (self.hero.position.x > self.pipeTop.position.x) {
            self.scores++;
            self.scoresLabel.text = [NSString stringWithFormat:@"%d", self.scores];
            self.lastPipe = self.pipeTop;
        }
    }
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *node = contact.bodyA.node;
    
    if ([node isKindOfClass:[EAHero class]]) {
        [self.obstacleTimer invalidate];
        [self runAction:[SKAction fadeAlphaTo:0.5f duration:0.2f]
             completion: ^{
                 [self gameOver];
             }];
    }
}

-(void)gameOver{
    SKTransition *transition = [SKTransition doorsCloseHorizontalWithDuration:0.3f];
    EAMenuScene *newGame = [[EAMenuScene alloc] initWithSize:self.size];
    [self.scene.view presentScene:newGame
                       transition:transition];
}

#pragma mark - Private API

-(NSString*)heroImageStateOne{
    return nil;
}

-(NSString*)heroImageStateTwo{
    return nil;
}

-(NSString*)topObstacleImage{
    return nil;
}

-(NSString*)bottomObstacleImage{
    return nil;
}

-(NSString*)backgroundImageName{
    return nil;
}

@end
