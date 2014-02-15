//
//  EAUFOGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EAUFOGameScene.h"
#import "EAHero.h"

static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;

static CGFloat const kDensity = 2.0f;


@interface EAUFOGameScene ()

@property (nonatomic, strong) EAHero *hero;

@end


@implementation EAUFOGameScene;

#pragma mark - SKScene overriden API

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.backgroundColor = [SKColor greenColor];
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0);
    
    [self addBackground];
    [self addHero];
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

#pragma mark - UIResponder overriden API

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self.hero fly];
    }
}

@end
