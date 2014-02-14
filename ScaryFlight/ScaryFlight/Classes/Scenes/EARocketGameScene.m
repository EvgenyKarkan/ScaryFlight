//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "EAHero.h"
static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;
static CGFloat const kDensity = 2.0f;
static CGFloat const kGravity = -2.0f;

@interface EARocketGameScene ()

@property (nonatomic, strong) EAHero *hero;

@end
@implementation EARocketGameScene;

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.physicsWorld.gravity = CGVectorMake(0.0f, kGravity);
    self.backgroundColor = [SKColor yellowColor];
    [self addBackground];
    [self addHero];
}

- (void)update:(NSTimeInterval)currentTime{
    
}

- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Space"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //UITouch *touch = [touches anyObject];
    //CGPoint positionInScene = [touch locationInNode:self];
    //[self selectNodeForTouch:positionInScene];
    CGPoint clickPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

   CGPoint charPos = self.hero.position;

   CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+

                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));


    SKAction *moveToClick = [SKAction moveTo:clickPoint duration:2.0];
    
    [self.hero runAction:moveToClick withKey:@"moveToClick"];
}

- (void)addHero
{
    self.hero = [EAHero spriteNodeWithImageNamed:@"UFO_hero_1"];
    self.hero.size = CGSizeMake(101.0f / 2.0f, 75.0f / 2.0f);
    [self.hero setPosition:CGPointMake(self.size.width / 2.0f, self.size.height / 2.0f)];
    
    NSArray *animationFrames = @[[SKTexture textureWithImageNamed:@"Rocket"],
                                 [SKTexture textureWithImageNamed:@"Rocket2"]];
    
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

@end
