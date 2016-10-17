//
//  OGMovement.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementComponent.h"
#import "OGConstants.h"

@interface OGMovementComponent ()

@property (nonatomic, retain) SKPhysicsBody *physicsBody;

@end

@implementation OGMovementComponent

- (instancetype)initWithPhysicsBody:(SKPhysicsBody *)body
{
    self = [super init];
    
    if (self)
    {
        _physicsBody = [body retain];
        _speedFactor = 1.0;
    }
    else
    {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)startMovementWithSpeed:(CGFloat)speed
{
    if (self.physicsBody)
    {
        CGVector vector = [OGConstants randomVectorWithLength:self.speedFactor * speed * self.physicsBody.mass];
        [self.physicsBody applyImpulse:vector];
    }
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    _speedFactor = speedFactor;
    
    
}

- (void)dealloc
{
    [_physicsBody release];
    
    [super dealloc];
}

@end
