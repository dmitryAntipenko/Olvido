//
//  OGMovement.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementComponent.h"
#import "OGRenderComponent.h"
#import "OGConstants.h"

CGFloat const kOGMovementComponentDefaultSpeedFactor = 1.0;
CGFloat const kOGMovementComponentDefaultSpeed = 200;

@interface OGMovementComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;

@end

@implementation OGMovementComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _speedFactor = kOGMovementComponentDefaultSpeedFactor;
    }
    
    return self;
}

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    self.renderComponent = (OGRenderComponent *) [self.entity componentForClass:[OGRenderComponent class]];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    CGVector force = CGVectorMake(kOGMovementComponentDefaultSpeed * self.speedFactor * self.direction.x, 0.0);
    
    self.renderComponent.sprite.physicsBody.velocity = force;
//    [self.renderComponent.sprite.physicsBody applyForce:force];
}

@end
