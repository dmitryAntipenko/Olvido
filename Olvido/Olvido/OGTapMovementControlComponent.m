//
//  OGTapMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapMovementControlComponent.h"

CGFloat const kOGTapMovementControlComponentDefaultSpeed = 500;
CGFloat const kOGTapMovementControlComponentDefaultSpeedFactor = 1.0;

@interface OGTapMovementControlComponent ()

@property (nonatomic, assign) CGFloat speedFactor;

@end

@implementation OGTapMovementControlComponent

- (instancetype)initWithNode:(SKNode *)node
{
    self = [super initWithNode:node];
    
    if (self)
    {
        _speedFactor = kOGTapMovementControlComponentDefaultSpeedFactor;
    }
    
    return self;
}

- (void)didTouchDownAtPoint:(CGPoint)point
{
    if (self.node && self.node.physicsBody)
    {
        CGVector displacementVector = CGVectorMake(point.x - self.node.position.x,
                                                   point.y - self.node.position.y);
        
        CGFloat displacement = pow(pow(displacementVector.dx, 2) + pow(displacementVector.dy, 2), 0.5);
        
        CGVector movementVector = self.node.physicsBody.velocity;
        
        CGFloat impulseX = displacementVector.dx / displacement * self.speedFactor * kOGTapMovementControlComponentDefaultSpeed - movementVector.dx;
        
        CGFloat impulseY = displacementVector.dy / displacement * self.speedFactor * kOGTapMovementControlComponentDefaultSpeed - movementVector.dy;
        
        [self.node.physicsBody applyImpulse:CGVectorMake(impulseX * self.node.physicsBody.mass,
                                                         impulseY * self.node.physicsBody.mass)];
    }
}

@end
