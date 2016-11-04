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

@interface OGMovementComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;

@end

@implementation OGMovementComponent

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    self.renderComponent = (OGRenderComponent *) [self.entity componentForClass:[OGRenderComponent class]];
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    _speedFactor = speedFactor;
    
//    CGVector velocity = self.physicsBody.velocity;
//    self.physicsBody.velocity = CGVectorMake(velocity.dx * speedFactor, velocity.dy * speedFactor);
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    CGFloat deltaX = self.renderComponent.sprite.position.x - self.destinationPoint.x;
    CGFloat deltaY = self.renderComponent.sprite.position.y - self.destinationPoint.y;
    
    CGFloat angle = atan(deltaY / deltaX);
    
    CGFloat dx = cosf(angle);
    CGFloat dy = sinf(angle);
    
    CGVector force = CGVectorMake(dx * 300, dy * 300);
    
    [self.renderComponent.sprite.physicsBody applyForce:force];
}

@end
