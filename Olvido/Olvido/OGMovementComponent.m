//
//  OGMovement.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementComponent.h"
#import "OGConstants.h"

CGFloat const kOGMovementComponentDefaultSpeedFactor = 1.0;

@implementation OGMovementComponent

- (void)startMovement
{
    if (self.physicsBody)
    {
        CGFloat vectorFactor = self.speedFactor * self.speed * self.physicsBody.mass;
        CGVector movementVector = CGVectorMake(self.dx * vectorFactor, self.dy * vectorFactor);
        [self.physicsBody applyImpulse:movementVector];
    }
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    _speedFactor = speedFactor;
    
    CGVector velocity = self.physicsBody.velocity;
    self.physicsBody.velocity = CGVectorMake(velocity.dx * speedFactor, velocity.dy * speedFactor);
}


- (void)dealloc
{
    [_physicsBody release];
    
    [super dealloc];
}

@end
