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

- (instancetype)initWithNode:(SKNode *)node speed:(CGFloat)speed
{
    self = [super initWithNode:node];
    
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
    if (self.node && self.node.physicsBody)
    {
        CGVector displacementVector = CGVectorMake(point.x - self.node.position.x,
                                                   point.y - self.node.position.y);
        
        CGFloat displacement = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGVector movementVector = self.node.physicsBody.velocity;
        
        CGFloat impulseX = displacementVector.dx / displacement * self.speedFactor * self.defaultSpeed - movementVector.dx;
        
        CGFloat impulseY = displacementVector.dy / displacement * self.speedFactor * self.defaultSpeed - movementVector.dy;
        
        [self.node.physicsBody applyImpulse:CGVectorMake(impulseX * self.node.physicsBody.mass,
                                                         impulseY * self.node.physicsBody.mass)];
    }
}

- (void)stop
{
    self.speedFactor = 0.0;
}

@end
