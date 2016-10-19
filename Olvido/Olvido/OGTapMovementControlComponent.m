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

@end

@implementation OGTapMovementControlComponent

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode speed:(CGFloat)speed
{
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        _defaultSpeed = speed;
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
    if (self.spriteNode && self.spriteNode.physicsBody)
    {
        CGVector displacementVector = CGVectorMake(point.x - self.spriteNode.position.x,
                                                   point.y - self.spriteNode.position.y);
        
        CGFloat displacement = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGVector movementVector = self.spriteNode.physicsBody.velocity;
        
        CGFloat impulseX = displacementVector.dx / displacement * self.speedFactor * self.defaultSpeed - movementVector.dx;
        
        CGFloat impulseY = displacementVector.dy / displacement * self.speedFactor * self.defaultSpeed - movementVector.dy;
        
        [self.spriteNode.physicsBody applyImpulse:CGVectorMake(impulseX * self.spriteNode.physicsBody.mass,
                                                         impulseY * self.spriteNode.physicsBody.mass)];
    }
}

- (void)stop
{
    self.speedFactor = 0.0;
}

@end
