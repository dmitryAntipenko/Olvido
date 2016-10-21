//
//  OGTapMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapMovementControlComponent.h"
#import "OGVisualComponent.h"
#import "OGSpriteNode.h"

CGFloat const kOGTapMovementControlComponentDefaultSpeed = 500;
CGFloat const kOGTapMovementControlComponentSpriteAnimateTimeInterval = 0.15;
NSString *const kOGTapMovementControlComponentSpriteAnimationActionKey = @"tapMovementControlComponentSpriteAnimationActionKey";

@interface OGTapMovementControlComponent ()

@property (nonatomic, assign) CGFloat defaultSpeed;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;


/*temporary*/
@property (nonatomic, retain) NSMutableArray<SKTexture *> *playerMovementRightTextures;
@property (nonatomic, retain) NSMutableArray<SKTexture *> *playerMovementLeftTextures;
/*temporary*/

@end

@implementation OGTapMovementControlComponent

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode speed:(CGFloat)speed
{
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        _defaultSpeed = speed;
        _targetPoint = CGPointZero;
        
        /*temporary*/
        SKTextureAtlas *playerMovingRightSpriteAtlas = [SKTextureAtlas atlasNamed:@"PlayerMovementImagesR"];
        _playerMovementRightTextures = [[NSMutableArray alloc] init];
        
        for (NSString *textureName in playerMovingRightSpriteAtlas.textureNames)
        {
            [_playerMovementRightTextures addObject:[playerMovingRightSpriteAtlas textureNamed:textureName]];
        }
        
        SKTextureAtlas *playerMovingLeftSpriteAtlas = [SKTextureAtlas atlasNamed:@"PlayerMovementImagesL"];
        _playerMovementLeftTextures = [[NSMutableArray alloc] init];
        
        for (NSString *textureName in playerMovingLeftSpriteAtlas.textureNames)
        {
            [_playerMovementLeftTextures addObject:[playerMovingLeftSpriteAtlas textureNamed:textureName]];
        }
        /*temporary*/
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    self.isMooving = YES;
    
    if (self.spriteNode && self.spriteNode.physicsBody)
    {
        self.targetPoint = point;
        CGVector displacementVector = CGVectorMake(point.x - self.spriteNode.position.x,
                                                   point.y - self.spriteNode.position.y);
        
        CGFloat displacement = hypot(displacementVector.dx, displacementVector.dy);
        
        CGFloat speedX = displacementVector.dx / displacement * self.speedFactor * self.defaultSpeed;
        
        CGFloat speedY = displacementVector.dy / displacement * self.speedFactor * self.defaultSpeed;
        
        self.spriteNode.physicsBody.velocity = CGVectorMake(speedX, speedY);
        
    }
    
    [self didChangeDirection];
}

- (void)didChangeDirection
{
    [self.spriteNode removeActionForKey:kOGTapMovementControlComponentSpriteAnimationActionKey];
    SKAction *moovingAnimation = nil;
    
    if (self.spriteNode.physicsBody.velocity.dx > 0)
    {
        moovingAnimation = [SKAction animateWithTextures:self.playerMovementRightTextures timePerFrame:kOGTapMovementControlComponentSpriteAnimateTimeInterval];
    }
    else
    {
        moovingAnimation = [SKAction animateWithTextures:self.playerMovementLeftTextures timePerFrame:kOGTapMovementControlComponentSpriteAnimateTimeInterval];
    }
    
    [self.spriteNode runAction:[SKAction repeatActionForever:moovingAnimation]];
}

- (void)stop
{
    [self.spriteNode removeActionForKey:kOGTapMovementControlComponentSpriteAnimationActionKey];
    self.speedFactor = 0.0;
}

- (void)dealloc
{
    [_playerMovementRightTextures release];
    [_playerMovementLeftTextures release];
    
    [super dealloc];
}

@end
