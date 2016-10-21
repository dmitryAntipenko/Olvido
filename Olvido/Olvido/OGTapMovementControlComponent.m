//
//  OGTapMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapMovementControlComponent.h"

CGFloat const kOGTapMovementControlComponentDefaultSpeed = 500;

@interface OGTapMovementControlComponent ()

@property (nonatomic, assign) CGFloat defaultSpeed;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@property (nonatomic, retain) NSMutableArray<SKTexture *> *playerMovementSprites;

@end

@implementation OGTapMovementControlComponent

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode speed:(CGFloat)speed
{
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        _defaultSpeed = speed;
        _targetPoint = CGPointZero;
        _playerMovementSprites = [[NSMutableArray alloc] init];
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
}

- (void)didChangeDirection
{
    NSLog(@"%@", NSStringFromCGVector(self.spriteNode.physicsBody.velocity));
}

- (void)stop
{
    self.speedFactor = 0.0;
}

- (void)dealloc
{
    [_playerMovementSprites release];
    
    [super dealloc];
}

@end
