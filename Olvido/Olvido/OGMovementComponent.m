//
//  OGMovement.m
//  Olvido
//
//  Created by Александр Песоцкий on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovementComponent.h"
#import "OGRenderComponent.h"
#import "OGAnimationComponent.h"
#import "OGOrientationComponent.h"

#import "OGConstants.h"

#import "OGAnimation.h"

CGFloat const OGMovementComponentDefaultSpeedFactor = 1.0;
CGFloat const OGMovementComponentDefaultSpeed = 5.0;

@interface OGMovementComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;

@end

@implementation OGMovementComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _speedFactor = OGMovementComponentDefaultSpeedFactor;
    }
    
    return self;
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    [super updateWithDeltaTime:seconds];
    
    CGPoint oldPosition = self.renderComponent.node.position;
    CGPoint newPosition = CGPointMake(oldPosition.x + self.displacementVector.dx * self.speedFactor * OGMovementComponentDefaultSpeed,
                                      oldPosition.y + self.displacementVector.dy * self.speedFactor * OGMovementComponentDefaultSpeed);
    
    self.renderComponent.node.position = newPosition;
}

- (OGRenderComponent *)renderComponent
{
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *) [self.entity componentForClass:[OGRenderComponent class]];
    }
    
    return _renderComponent;
}

- (OGAnimationComponent *)animationComponent
{
    if (!_animationComponent)
    {
        _animationComponent = (OGAnimationComponent *) [self.entity componentForClass:[OGAnimationComponent class]];
    }
    
    return _animationComponent;
}

@end
