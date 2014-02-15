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


static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;

static CGFloat const kDensity       = 2.0f;
static CGFloat const kPipeSpeed     = 4.5f;
static CGFloat const kPipeWidth     = 56.0f;
static CGFloat const kPipeGap       = 80.0f;
static CGFloat const kPipeFrequency = 2.5f;
static CGFloat const kGroundHeight  = 6.0f;


@interface EABaseGameScene ()

@property (nonatomic, strong) EAHero *hero;
@property (nonatomic, strong) NSTimer *obstacleTimer;
@property (nonatomic ,strong) SKLabelNode * scoresLabel;
@property (nonatomic ,assign) int  scores;
@end


@implementation EABaseGameScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -3.0f);
    
    [self addBackground];
    [self addHero];
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency
                                                          target:self
                                                        selector:@selector(addObstacle)
                                                        userInfo:nil
                                                         repeats:YES];
    
    _scoresLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    _scoresLabel.fontSize = 30;
    _scoresLabel.fontColor = [SKColor yellowColor];
    _scoresLabel.position = CGPointMake(self.size.width-30,self.size.height-30);
    [self addChild:_scoresLabel];
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

- (void)addObstacle
{
    CGFloat centerY = [self randomFloatWithMin:kPipeGap * 1.5f max:(self.size.height - kPipeGap * 1.5f)];
    
    EAObstacle *pipeTop = [EAObstacle obstacleWithImageNamed:@"UFO_top_pipe"];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    [pipeTop moveObstacleWithScale:pipeTopHeight / kPipeWidth];
    pipeTop.position = CGPointMake(self.size.width + (pipeTop.size.width / 2.0f), self.size.height - (pipeTop.size.height / 2.0f));
    [self addChild:pipeTop];
    
    EAObstacle *pipeBottom = [EAObstacle obstacleWithImageNamed:@"UFO_down_pipe"];
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    [pipeBottom moveObstacleWithScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    pipeBottom.position = CGPointMake(self.size.width + (pipeBottom.size.width / 2.0f), (pipeBottom.size.height / 2.0f) + (kGroundHeight - 2.0f));
    [self addChild:pipeBottom];
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

-(void)update:(NSTimeInterval)currentTime{
    [super update:currentTime];
     _scoresLabel.text = [NSString stringWithFormat:@"%d",_scores];
}

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
