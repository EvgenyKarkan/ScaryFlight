//
//  EARocketGameScene.m
//  ScaryFlight
//
//  Created by Evgeny Karkan on 14.02.14.
//  Copyright (c) 2014 EvgenyKarkan. All rights reserved.
//

#import "EARocketGameScene.h"
#import "EAHero.h"
#import  "EAObstacle.h"

static uint32_t const kHeroCategory   = 0x1 << 0;
static uint32_t const kPipeCategory   = 0x1 << 1;
static uint32_t const kGroundCategory = 0x1 << 2;
static CGFloat const kDensity = 2.0f;
static CGFloat const kGravity = -2.0f;

@interface EARocketGameScene ()

@property (nonatomic, strong) EAHero *hero;
@property (nonatomic, strong) NSMutableArray *obstaclesArray;
@end


@implementation EARocketGameScene;

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.physicsWorld.gravity = CGVectorMake(0.0f, kGravity);
    self.backgroundColor = [SKColor yellowColor];
    [self addBackground];
    [self addHero];
    [self addObstacles];
}

- (void)update:(NSTimeInterval)currentTime{
    
}

-(void)addObstacles{
    CGPoint startPointTop = CGPointMake(self.size.width, self.size.height-50);
    SKSpriteNode *obstacleTop = [EAObstacle spriteNodeWithImageNamed:@"AsteroidTop"];
    obstacleTop.position = CGPointMake(startPointTop.x, startPointTop.y);
    obstacleTop.name = @"obstacle0";
 
   
    SKAction * topObstacleAction =[SKAction moveTo:CGPointMake( -20,  self.size.height-50 ) duration:5 ] ;
    //id __weak block  =
    void (^__block CompleteTopObstacleAnimation)() ;
    __block id __weak weakBlock ;
    CompleteTopObstacleAnimation = ^()
    {
        obstacleTop.position = CGPointMake(startPointTop.x, startPointTop.y);
        weakBlock= CompleteTopObstacleAnimation;
        [obstacleTop runAction:topObstacleAction completion:weakBlock ];
    };
    
    CompleteTopObstacleAnimation();
    //need to refactor fuck!
    [self addChild:obstacleTop];
    
    CGPoint startPointBottom = CGPointMake(self.size.width, 50);
    SKSpriteNode *obstacleBottom = [EAObstacle spriteNodeWithImageNamed:@"AsteroidDown"];
    obstacleBottom.position = CGPointMake(startPointBottom.x, startPointBottom.y);
    obstacleBottom.name = @"obstacle0";
    
    SKAction * bottomObstacleAction =[SKAction moveTo:CGPointMake( -20,  50 ) duration:5 ] ;
    [obstacleBottom runAction:[SKAction repeatActionForever:bottomObstacleAction ] completion:^{
        obstacleBottom.position = CGPointMake(startPointBottom.x, startPointBottom.y);
    } ];
    [self addChild:obstacleBottom];
    
}
- (void)addBackground
{
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Space"];
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:backgroundTexture size:self.view.frame.size];
    background.position = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    [self addChild:background];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self.hero fly];
    }
}

- (void)addHero
{
    self.hero = [EAHero spriteNodeWithImageNamed:@"Rocket"];
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
