//
//  OGFlameScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGFlameScene.h"
#import "OGGameScene+OGGameSceneCreation.h"
#import "OGTimer.h"

typedef NS_ENUM (NSUInteger, OGFlameLocation)
{
    kOGFlameLocationHorizontal = 0,
    kOGFlameLocationVertical = 1
};

NSString *const kOGFlameSceneParticleFileName = @"Flame";
NSString *const kOGFlameSceneParticleFileExtension = @"sks";
NSString *const kOGFlameSceneFlameNodeName = @"flameNode";

NSUInteger const kOGFlameChangeInterval = 5.0;

@interface OGFlameScene ()

@property (nonatomic, retain) NSMutableArray<SKEmitterNode *> *flames;
@property (nonatomic, assign) NSUInteger currentFlameLocation;
@property (nonatomic, retain) NSTimer *timer;

@end

@implementation OGFlameScene

- (instancetype)initWithSize:(CGSize)size
{
    self = [super initWithSize:size];
    
    if (self)
    {
        _flames = [[NSMutableArray alloc] init];
        _currentFlameLocation = 0;
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
    [super createSceneContents];
    
    self.backgroundColor = [SKColor gameBlack];

    [self createEnemies];
    for (OGEntity *enemy in self.enemies)
    {
        ((OGVisualComponent *) [enemy componentForClass:[OGVisualComponent class]]).color = [SKColor gameWhite];
    }
    
    [self createPlayer];
    ((OGVisualComponent *) [self.player componentForClass:[OGVisualComponent class]]).color = [SKColor gameWhite];
    
    [self createFlameAtPoint:CGPointMake(CGRectGetMidX(self.frame), 0.0) emissionAngle:M_PI_2];
    [self createFlameAtPoint:CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height) emissionAngle:3 * M_PI_2];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kOGFlameChangeInterval
                                                      target:self
                                                    selector:@selector(changeFlameLocation)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)createFlameAtPoint:(CGPoint)point emissionAngle:(CGFloat)angle
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kOGFlameSceneParticleFileName
                                                     ofType:kOGFlameSceneParticleFileExtension];
    
    SKEmitterNode *flame = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    flame.targetNode = self;
    flame.position = point;
    flame.emissionAngle = angle;
    
    CGFloat flameTriggerHeightHalf = flame.particleLifetime * (flame.particleSpeed - flame.particleSpeedRange);
    
    CGRect flameTriggerRect = CGRectMake(-flame.particlePositionRange.dx / 2,
                                         -flameTriggerHeightHalf,
                                         flame.particlePositionRange.dx,
                                         flameTriggerHeightHalf * 2);
    
    flame.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:flameTriggerRect];
    flame.physicsBody.categoryBitMask = kOGCollisionBitMaskFlame;
    flame.physicsBody.collisionBitMask = kOGCollisionBitMaskDefault;
    flame.physicsBody.contactTestBitMask = kOGCollisionBitMaskDefault;

    flame.name = kOGFlameSceneFlameNodeName;
    
    [self.flames addObject:flame];
    [self addChild:flame];
}

- (void)changeFlameLocation
{
    self.currentFlameLocation = (self.currentFlameLocation + 1) % 2;
    SKAction *rotation = [SKAction rotateByAngle:M_PI_2 duration:0.0];
    
    if (self.currentFlameLocation == kOGFlameLocationHorizontal)
    {
        for (NSUInteger i = 0; i < self.flames.count; i++)
        {
            self.flames[i].position = CGPointMake(CGRectGetMidX(self.frame), i * self.frame.size.height);
            self.flames[i].emissionAngle = ((i * 2.0) + 1.0) * M_PI_2;
            [self.flames[i] runAction:rotation];
        
        }
    }
    else if (self.currentFlameLocation == kOGFlameLocationVertical)
    {
        for (NSUInteger i = 0; i < self.flames.count; i++)
        {
            self.flames[i].position = CGPointMake(self.frame.size.width * i, CGRectGetMidY(self.frame));
            self.flames[i].emissionAngle = i * M_PI;
            [self.flames[i] runAction:rotation];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchBeganAtPoint:touchLocation];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchMovedToPoint:touchLocation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    
    [self.playerMovementControlComponent touchEndedAtPoint:touchLocation];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    [super didBeginContact:contact];
}

- (void)dealloc
{
    [_timer invalidate];
    [_timer release];
    [_flames release];
    
    [super dealloc];
}

@end
