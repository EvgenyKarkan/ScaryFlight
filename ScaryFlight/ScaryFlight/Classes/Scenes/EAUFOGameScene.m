//
//  EAUFOGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUFOGameScene.h"
#import "EAHero.h"
#import "EAObstacle.h"

static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;

static CGFloat const kDensity = 2.0f;


static const CGFloat kPipeSpeed = 4.5f;
static const CGFloat kPipeWidth = 56.0;
static const CGFloat kPipeGap = 100;
static const CGFloat kPipeFrequency = 3.0f;

static const CGFloat kGroundHeight = 6.0;

@interface EAUFOGameScene ()

@property (nonatomic, strong) EAHero *hero;
@property (nonatomic, strong) NSTimer *obstacleTimer;

@end


@implementation EAUFOGameScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.backgroundColor = [SKColor greenColor];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -3.0);
    
    [self addBackground];
    [self addHero];
    
    self.obstacleTimer = [NSTimer scheduledTimerWithTimeInterval:kPipeFrequency
                                                          target:self
                                                        selector:@selector(addObstacle)
                                                        userInfo:nil
                                                         repeats:YES];
}

#pragma mark - Setup sprites

- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"City"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}

- (void)addHero
{
    self.hero = [EAHero spriteNodeWithImageNamed:@"UFO_new_hero"];
    self.hero.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    [self.hero setPosition:CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"UFO_new_hero"],
                                 [SKTexture textureWithImageNamed:@"UFO_new_hero2"]];
    
    SKAction *heroAction = [SKAction repeatActionForever:[SKAction animateWithTextures:animationFrames
                                                                          timePerFrame:0.1f
                                                                                resize:NO
                                                                               restore:YES]];
    [self.hero runAction:heroAction withKey:@"flyingHero"];
    [self addChild:self.hero];
    
    self.hero.physicsBody                    = [SKPhysicsBody bodyWithRectangleOfSize:self.hero.size];
    self.hero.physicsBody.density            = kDensity;
    self.hero.physicsBody.allowsRotation     = NO;
    self.hero.physicsBody.categoryBitMask    = kHeroCategory;
    self.hero.physicsBody.contactTestBitMask = kPipeCategory | kGroundCategory;
    self.hero.physicsBody.collisionBitMask   = kGroundCategory | kPipeCategory;
}

- (void)addObstacle
{
    CGFloat centerY = [self randomFloatWithMin:kPipeGap max:self.size.height - kPipeGap];
    CGFloat pipeTopHeight = centerY - (kPipeGap / 2.0f);
    CGFloat pipeBottomHeight = self.size.height - (centerY + (kPipeGap / 2.0f));
    
        // Top Pipe
    EAObstacle *pipeTop = [EAObstacle spriteNodeWithImageNamed:@"UFO_top_pipe"];
    [pipeTop setCenterRect:CGRectMake(26.0 / kPipeWidth, 26.0 / kPipeWidth, 4.0 / kPipeWidth, 4.0 / kPipeWidth)];
    [pipeTop setYScale:pipeTopHeight / kPipeWidth];
    [pipeTop setPosition:CGPointMake(self.size.width + (pipeTop.size.width / 2) + 20.0f, self.size.height - (pipeTop.size.height / 2))];
    [self addChild:pipeTop];
    
    pipeTop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeTop.size];
    [pipeTop.physicsBody setAffectedByGravity:NO];
    [pipeTop.physicsBody setDynamic:NO];
    [pipeTop.physicsBody setCategoryBitMask:kPipeCategory];
    [pipeTop.physicsBody setCollisionBitMask:kHeroCategory];
    
        // Bottom Pipe
    EAObstacle *pipeBottom = [EAObstacle spriteNodeWithImageNamed:@"UFO_down_pipe"];
    [pipeBottom setCenterRect:CGRectMake(26.0 / kPipeWidth, 26.0 / kPipeWidth, 4.0 / kPipeWidth, 4.0 / kPipeWidth)];
    [pipeBottom setYScale:(pipeBottomHeight - kGroundHeight) / kPipeWidth];
    [pipeBottom setPosition:CGPointMake(self.size.width + (pipeBottom.size.width / 2) + 20.0f, (pipeBottom.size.height / 2) + (kGroundHeight - 2))];
    [self addChild:pipeBottom];
    
    pipeBottom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipeBottom.size];
    [pipeBottom.physicsBody setAffectedByGravity:NO];
    [pipeBottom.physicsBody setDynamic:NO];
    
    [pipeBottom.physicsBody setCategoryBitMask:kPipeCategory];
    [pipeBottom.physicsBody setCollisionBitMask:kHeroCategory];
    
        // Move top pipe
    SKAction *pipeTopAction = [SKAction moveToX:-(pipeTop.size.width / 2) duration:kPipeSpeed];
    SKAction *pipeTopSequence = [SKAction sequence:@[pipeTopAction, [SKAction runBlock: ^{
        [pipeTop removeFromParent];
    }]]];
    
    [pipeTop runAction:[SKAction repeatActionForever:pipeTopSequence]];
    
        // Move bottom pipe
    SKAction *pipeBottomAction = [SKAction moveToX:-(pipeBottom.size.width / 2) duration:kPipeSpeed];
    SKAction *pipeBottomSequence = [SKAction sequence:@[pipeBottomAction, [SKAction runBlock: ^{
        [pipeBottom removeFromParent];
    }]]];
    
    [pipeBottom runAction:[SKAction repeatActionForever:pipeBottomSequence]];
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

@end
