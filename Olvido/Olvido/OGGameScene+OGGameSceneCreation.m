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
#import "OGScoreController.h"

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
CGFloat const kOGGameScenePlayerAppearanceDelay = 0.1;
CGFloat const kOGGameScenePlayerSpeedIncreaseFactor = 1.2;

CGFloat const kOGGameSceneCoinPositionFrameOffset = 40.0;

CGFloat const kOGGameSceneStatusBarAlpha = 0.5;
CGFloat const kOGGameSceneStatusBarPositionOffset = 10.0;

NSString *const kOGGameSceneScoreLabelFontName = @"Helvetica";
CGFloat const kOGGameSceneScoreIncrementInterval = 1.0;
CGFloat const kOGGameSceneScoreLabelYPosition = -13.0;
NSUInteger const kOGGameSceneScoreLabelFontSize = 32;
NSString *const kOGGameSceneDefaultScoreValue = @"0";

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
    
    OGTimer *coinsCreationTimer = [[OGTimer alloc] init];
    self.coinsCreationTimer = coinsCreationTimer;
    [coinsCreationTimer release];
    
    [self.coinsCreationTimer startWithInterval:kOGGameSceneCoinAppearanceInterval
                                      selector:@selector(createCoin)
                                        sender:self];
    
    OGTimer *scoreTimer = [[OGTimer alloc] init];
    self.scoreTimer = scoreTimer;
    [scoreTimer release];
    
    [self.scoreTimer startWithInterval:kOGGameSceneScoreIncrementInterval
                              selector:@selector(timerTick)
                                sender:self];
    
    [self createStatusBar];
    [self createScoreController];
}

- (void)timerTick
{
    [self.scoreController incrementScore];
    self.scoreLabel.text = self.scoreController.score.stringValue;
}

- (void)createScoreController
{
    OGScoreController *scoreController = [[OGScoreController alloc] init];
    
    self.scoreController = scoreController;
    
    [scoreController release];
}

- (void)createStatusBar
{
    SKSpriteNode *statusBarSprite = [SKSpriteNode spriteNodeWithImageNamed:kOGStatusBarBackgroundTextureName];
    
    statusBarSprite.alpha = kOGGameSceneStatusBarAlpha;
    statusBarSprite.zPosition = 4;
    
    CGFloat statusBarY = self.frame.size.height - statusBarSprite.size.height / 2.0 - kOGGameSceneStatusBarYOffset;
    statusBarSprite.position = CGPointMake(CGRectGetMidX(self.frame), statusBarY);
    
    SKTexture *pauseButtonTexture = [SKTexture textureWithImageNamed:kOGPauseButtonTextureName];
    SKSpriteNode *pauseButton = [SKSpriteNode spriteNodeWithTexture:pauseButtonTexture];
    
    pauseButton.name = kOGPauseButtonName;
    pauseButton.position = CGPointMake(statusBarSprite.size.width / 2.0 - pauseButton.size.width / 2.0 - kOGGameSceneStatusBarPositionOffset,
                                       0.0);
    
    [statusBarSprite addChild:pauseButton];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:kOGGameSceneScoreLabelFontName];
    scoreLabel.fontSize = kOGGameSceneScoreLabelFontSize;
    scoreLabel.text = kOGGameSceneDefaultScoreValue;
    scoreLabel.position = CGPointMake(0.0, kOGGameSceneScoreLabelYPosition);
    
    self.scoreLabel = scoreLabel;
    [statusBarSprite addChild:scoreLabel];
    
    self.statusBar = statusBarSprite;
    self.statusBarMinDistance = self.statusBar.size.height * 2.0;
    [self addChild:statusBarSprite];
}

- (void)createPauseBar
{
    if (!self.pauseBarSprite)
    {
        SKSpriteNode *pauseBarSprite = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor]
                                                                    size:CGSizeMake(self.scene.size.width, self.scene.size.height / 3.5)];
        
        CGSize buttonSize = CGSizeMake(70.0, 70.0);
        
        SKSpriteNode *resume = [SKSpriteNode spriteNodeWithImageNamed:kOGGameSceneResumeName];
        resume.name = kOGGameSceneResumeName;
        resume.position = CGPointMake(-100.0, 0.0);
        resume.size = buttonSize;
        
        SKSpriteNode *menu = [SKSpriteNode spriteNodeWithImageNamed:kOGGameSceneMenuName];
        menu.name = kOGGameSceneMenuName;
        menu.position = CGPointMake(0.0, 0.0);
        menu.size = buttonSize;
        
        SKSpriteNode *restart = [SKSpriteNode spriteNodeWithImageNamed:kOGGameSceneRestartName];
        restart.name = kOGGameSceneRestartName;
        restart.position = CGPointMake(100.0, 0.0);
        restart.size = buttonSize;
        
        self.pauseBarSprite = pauseBarSprite;
        
        [self.pauseBarSprite addChild:resume];
        [self.pauseBarSprite addChild:menu];
        [self.pauseBarSprite addChild:restart];
    }
    
    self.pauseBarSprite.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame));
    [self addChild:self.pauseBarSprite];
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
    sprite.alpha = 0.0;
    
    if (self.exitPortalLocation == kOGPortalLocationUp)
    {
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
    }
    else if (self.exitPortalLocation == kOGPortalLocationDown)
    {
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), 0.0);
    }
    else if (self.exitPortalLocation == kOGPortalLocationLeft)
    {
        sprite.position = CGPointMake(self.frame.size.width, CGRectGetMidY(self.frame));
    }
    else if (self.exitPortalLocation == kOGPortalLocationRight)
    {
        sprite.position = CGPointMake(0.0, CGRectGetMidY(self.frame));
    }
    else
    {
        sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    }
    
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
    
    self.playerVisualComponent = visualComponent;
    [player addComponent:visualComponent];
    
    /* temporary code */
    OGMovementControlComponent *movementControlComponent = nil;
    
    if ([self.controlType isEqualToString:@"Drag"])
    {
        movementControlComponent = [[OGDragMovementControlComponent alloc] initWithSpriteNode:sprite];
    }
    else
    {
        movementControlComponent = [[OGTapMovementControlComponent alloc] initWithSpriteNode:sprite
                                                                                       speed:self.enemySpeed * kOGGameScenePlayerSpeedIncreaseFactor];
    }
    /* temporary code */
    
    self.playerMovementControlComponent = movementControlComponent;
    [player addComponent:movementControlComponent];
    
    self.player = player;
    [self addChild:sprite];
    
    SKAction *wait = [SKAction waitForDuration:kOGGameScenePlayerAppearanceDelay];
    
    SKAction *show = [SKAction fadeInWithDuration:kOGGameScenePlayerAppearanceDelay];
    
    SKAction *sequence = [SKAction sequence:@[wait, show]];
    
    [sprite runAction:sequence];
    
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
        
        [self addEnemy:enemy];
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

- (void)createCoin
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
        sprite.position = [self randomCoinPositionWithCoinRadius:coinRadius];
        
        [coin addComponent:visualComponent];
        [self addCoin:coin];
        [self addChild:sprite];
        
        SKAction *destroyCoin = [SKAction sequence:@[
                                                     [SKAction waitForDuration:kOGGameSceneCoinLifeTime],
                                                     [SKAction fadeOutWithDuration:kOGGameSceneCoinFadeOutDuration]
                                                     ]];
        
        [sprite runAction:destroyCoin completion:^()
         {
             [self removeCoin:coin];
             [sprite removeFromParent];
         }];
        
        [visualComponent release];
    }
}

- (CGPoint)randomCoinPositionWithCoinRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(self.frame.origin.x + kOGGameSceneCoinPositionFrameOffset,
                             self.frame.origin.y + kOGGameSceneCoinPositionFrameOffset,
                             self.frame.size.width - kOGGameSceneCoinPositionFrameOffset * 2.0,
                             self.frame.size.height - kOGGameSceneCoinPositionFrameOffset * 2.0);
    
    CGPoint possiblePoint = CGPointZero;
    __block BOOL keepSearching = YES;
    
    while (keepSearching)
    {
        keepSearching = NO;
        possiblePoint = [OGConstants randomPointInRect:rect];
        CGRect pointRect = CGRectMake(possiblePoint.x - radius, possiblePoint.y - radius, radius * 2.0, radius * 2.0);
        
        for (SKNode *node in self.children)
        {
            if ([node isKindOfClass:[SKSpriteNode class]])
            {
                SKSpriteNode *sprite = (SKSpriteNode *) node;
                
                CGRect spriteRect = CGRectMake(sprite.position.x - sprite.size.width / 2.0,
                                               sprite.position.y - sprite.size.height / 2.0,
                                               sprite.size.width,
                                               sprite.size.height);
                
                if (CGRectIntersectsRect(pointRect, spriteRect))
                {
                    keepSearching = YES;
                }
            }
        }
    }
    
    return possiblePoint;
}

- (void)addPortalToScene:(OGEntity *)portal
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
    
    [self addPortal:portal];
    [self addChild:visualComponent.spriteNode];
}

@end
