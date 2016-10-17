//
//  OGGameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"
#import "OGTrackMovementControlComponent.h"
#import "OGTapMovementControlComponent.h"

CGFloat const kOGGameSceneEnemyDefaultSpeed = 3.0;
CGFloat const kOGGameSceneScaleFactor = 4.0;

CGFloat const kOGEnemyLinearDamping = 0.0;
CGFloat const kOGEnemyAngularDamping = 0.0;
CGFloat const kOGEnemyFriction = 0.0;
CGFloat const kOGEnemyRestitution = 1.0;
CGFloat const kOGEnemyMass = 0.01;

@interface OGGameScene ()

@property (nonatomic, readonly) CGFloat enemySpeed;

@end

@implementation OGGameScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _enemies = [[NSMutableArray alloc] init];
        _portals = [[NSMutableArray alloc] init];
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)createSceneContents
{
    
}

- (CGFloat)enemySpeed
{
    return self.frame.size.height * kOGGameSceneEnemyDefaultSpeed / kOGGameSceneScaleFactor;
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
        sprite.physicsBody.linearDamping = kOGEnemyLinearDamping;
        sprite.physicsBody.angularDamping = kOGEnemyAngularDamping;
        sprite.physicsBody.friction = kOGEnemyFriction;
        sprite.physicsBody.restitution = kOGEnemyRestitution;
        sprite.physicsBody.mass = kOGEnemyMass;
        
        sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskEnemy;
        sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
        sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;
        
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

- (void)createPlayer
{
    OGEntity *player = [OGEntity entity];
    
    OGVisualComponent *visualComponent = [[OGVisualComponent alloc] init];
    visualComponent.spriteNode = [OGSpriteNode spriteNodeWithImageNamed:kOGPlayerTextureName];
    visualComponent.color = [SKColor gameBlack];
    
    OGSpriteNode *sprite = visualComponent.spriteNode;
    sprite.owner = visualComponent;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width / 2.0];
    sprite.physicsBody.dynamic = YES;
    
    sprite.physicsBody.categoryBitMask = kOGCollisionBitMaskPlayer;
    sprite.physicsBody.collisionBitMask = kOGCollisionBitMaskObstacle;
    sprite.physicsBody.contactTestBitMask = kOGCollisionBitMaskObstacle | kOGCollisionBitMaskEnemy;
    
    sprite.physicsBody.friction = 0.0;
    sprite.physicsBody.restitution = 1.0;
    sprite.physicsBody.linearDamping = 0.0;
    sprite.physicsBody.angularDamping = 0.0;
    
    [player addComponent:visualComponent];
    
//    OGMovementControlComponent *trackMovementControlComponent = [[OGTrackMovementControlComponent alloc] initWithNode:sprite];
//    self.playerMovementControlComponent = trackMovementControlComponent;
//    [player addComponent:trackMovementControlComponent];
    
    OGMovementControlComponent *movementControlComponent = [[OGTapMovementControlComponent alloc] initWithNode:sprite];
    self.playerMovementControlComponent = movementControlComponent;
    [player addComponent:movementControlComponent];
    
    self.player = player;
    [self addChild:sprite];
    
    [visualComponent release];
    [movementControlComponent release];
}

- (void)addPortal:(OGEntity *)portal
{
    OGTransitionComponent *transitionComponent = (OGTransitionComponent *) [portal componentForClass:[OGTransitionComponent class]];
    OGVisualComponent *visualComponent = (OGVisualComponent *) [portal componentForClass:[OGVisualComponent class]];
    
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

- (void)dealloc
{
    [_enemies release];
    [_player release];
    [_identifier release];
    [_portals release];
    [_sceneDelegate release];
    [_enemiesCount release];
    
    [super dealloc];
}

@end
