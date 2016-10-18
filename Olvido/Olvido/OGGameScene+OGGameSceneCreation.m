//
//  OGGameScene+OGGameSceneCreation.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene+OGGameSceneCreation.h"

#import "OGEntity.h"
#import "OGVisualComponent.h"
#import "OGTransitionComponent.h"
#import "OGMovementComponent.h"
#import "OGMovementControlComponent.h"
#import "OGSpriteNode.h"
#import "OGDragMovementControlComponent.h"
#import "OGTapMovementControlComponent.h"

CGFloat const kOGGameSceneCoinAppearanceInterval = 8.0;
CGFloat const kOGGameSceneCoinLifeTime = 3.0;
NSUInteger const kOGGameSceneMaxCoinCount = 10;
CGFloat const kOGGameSceneCoinFadeOutDuration = 0.5;

CGFloat const kOGDefaultLinearDamping = 0.0;
CGFloat const kOGDefaultAngularDamping = 0.0;
CGFloat const kOGDefaultFriction = 0.0;
CGFloat const kOGDefaultRestitution = 1.0;
CGFloat const kOGDefaultMass = 0.01;

CGFloat const kOGGameSceneBorderSize = 3.0;

CGFloat const kOGGameSceneEnemyDefaultSpeed = 2.0;
CGFloat const kOGGameSceneScaleFactor = 4.0;

@interface OGGameScene ()

@property (nonatomic, readonly) CGFloat enemySpeed;

@end

@implementation OGGameScene (OGGameSceneCreation)

- (void)createSceneContents
{
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = kOGCollisionBitMaskObstacle;
    self.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    self.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
    self.physicsWorld.contactDelegate = self;
    
    [NSTimer scheduledTimerWithTimeInterval:kOGGameSceneCoinAppearanceInterval
                                     target:self
                                   selector:@selector(addCoin)
                                   userInfo:nil
                                    repeats:YES];
}

- (SKCropNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKSpriteNode *border = [SKSpriteNode spriteNodeWithColor:color
                                                        size:self.frame.size];
    
    border.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = pow(kOGGameSceneBorderSize, 2);
    
    SKCropNode *crop = [SKCropNode node];
    crop.maskNode = mask;
    [crop addChild:border];
    
    CGPathRelease(path);
    
    return crop;
}

- (void)createPlayer
{
    OGEntity *player = [OGEntity entity];
    
    OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
    visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGPlayerTextureName];
    visualComponent.color = [SKColor gameBlack];
    
    OGSpriteNode *sprite = visualComponent.spriteNode;
    sprite.owner = visualComponent;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGFloat playerRadius = sprite.size.width / 2.0;
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:playerRadius];
    sprite.physicsBody.dynamic = YES;
    
    sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskPlayer;
    sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
    sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskEnemy | kOGCollisionBitMaskFlame | kOGCollisionBitMaskCoin | kOGCollisionBitMaskPortal;
    
    sprite.name = kOGPlayerNodeName;
    sprite.physicsBody.friction = kOGDefaultFriction;
    sprite.physicsBody.restitution = kOGDefaultRestitution;
    sprite.physicsBody.linearDamping = kOGDefaultLinearDamping;
    sprite.physicsBody.angularDamping = kOGDefaultAngularDamping;
    sprite.physicsBody.mass = kOGDefaultMass;
    
    [player addComponent:visualComponent];
    
    OGMovementControlComponent *movementControlComponent = nil;
    
    if ([self.controlType isEqualToString:@"Drag"])
    {
        movementControlComponent = [[OGDragMovementControlComponent alloc] initWithNode:sprite];
    }
    else
    {
        movementControlComponent = [[OGTapMovementControlComponent alloc] initWithNode:sprite];
    }
    
    self.playerMovementControlComponent = movementControlComponent;
    [player addComponent:movementControlComponent];
    
    self.player = player;
    [self addChild:sprite];
    
    [visualComponent release];
    [movementControlComponent release];
}

- (void)createEnemies
{
    for (NSUInteger i = 0; i < self.enemiesCount.integerValue; i++)
    {
        OGEntity *enemy = [OGEntity entity];
        
        OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
        visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGEnemyTextureName];
        visualComponent.color = [SKColor gameBlack];
        
        OGSpriteNode *sprite = visualComponent.spriteNode;
        sprite.owner = visualComponent;
        sprite.position = [OGConstants randomPointInRect:self.frame];
        
        CGFloat enemyRadius = visualComponent.spriteNode.size.width / 2.0;
        
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyRadius];
        sprite.physicsBody.linearDamping = kOGDefaultLinearDamping;
        sprite.physicsBody.angularDamping = kOGDefaultAngularDamping;
        sprite.physicsBody.friction = kOGDefaultFriction;
        sprite.physicsBody.restitution = kOGDefaultRestitution;
        sprite.physicsBody.mass = kOGDefaultMass;
        
        sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskEnemy;
        sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
        sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
        
        sprite.name = kOGEnemyNodeName;
        
        [enemy addComponent:visualComponent];
        
        OGMovementComponent *movementComponent = [[OGMovementComponent alloc] initWithPhysicsBody:sprite.physicsBody];
        [enemy addComponent:movementComponent];
        
        [self.enemies addObject:enemy];
        [self addChild:sprite];
        
        [movementComponent startMovementWithSpeed:self.enemySpeed];
        
        [visualComponent release];
        [movementComponent release];
    }
}

- (CGFloat)enemySpeed
{
    return self.frame.size.height * kOGGameSceneEnemyDefaultSpeed / kOGGameSceneScaleFactor;
}

- (void)addCoin
{
    if (self.coins.count < kOGGameSceneMaxCoinCount)
    {
        OGEntity *coin = [OGEntity entity];
        
        OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
        visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGCoinTextureName];
        visualComponent.color = [SKColor yellowColor];
        
        OGSpriteNode *sprite = visualComponent.spriteNode;
        
        CGFloat coinRadius = sprite.size.width / 2.0;
        
        sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:coinRadius];
        sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskCoin;
        sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
        sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
        
        sprite.owner = visualComponent;
        sprite.name = kOGCoinNodeName;
        sprite.position = [OGConstants randomPointInRect:self.frame];
        
        [coin addComponent:visualComponent];
        [self.coins addObject:coin];
        [self addChild:sprite];
        
        SKAction *destroyCoin = [SKAction sequence:@[
                                                     [SKAction waitForDuration:kOGGameSceneCoinLifeTime],
                                                     [SKAction fadeOutWithDuration:kOGGameSceneCoinFadeOutDuration]
                                                     ]];
        
        [sprite runAction:destroyCoin completion:^()
         {
             [self.coins removeObject:coin];
             [sprite removeFromParent];
         }];
        
        [visualComponent release];
    }
}

- (void)addPortal:(OGEntity *)portal
{
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
    OGVisualComponent *visualComponent = (OGVisualComponent *) [portal componentForClass:[OGVisualComponent class]];
    
    visualComponent.spriteNode.name = kOGPortalNodeName;
    visualComponent.spriteNode.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:visualComponent.spriteNode.frame];
    visualComponent.spriteNode.physicsBody.categoryBitMask = kOGCollisionBitMaskPortal;
    visualComponent.spriteNode.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
    visualComponent.spriteNode.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    
    if (transitionComponent)
    {
        if (transitionComponent.location == kOGPortalLocationUp)
        {
            visualComponent.spriteNode.position = CGPointMake(CGRectGetMidX(self.frame), 0.0);
        }
        else if (transitionComponent.location == kOGPortalLocationDown)
        {
            visualComponent.spriteNode.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
        }
        else if (transitionComponent.location == kOGPortalLocationLeft)
        {
            visualComponent.spriteNode.position = CGPointMake(0.0, CGRectGetMidY(self.frame));
        }
        else if (transitionComponent.location == kOGPortalLocationRight)
        {
            visualComponent.spriteNode.position = CGPointMake(self.frame.size.width, CGRectGetMidY(self.frame));
        }
    }
    
    [self.portals addObject:portal];
    [self addChild:visualComponent.spriteNode];
}

@end
