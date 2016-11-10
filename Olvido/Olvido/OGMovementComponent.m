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

CGFloat const kOGMovementComponentDefaultSpeedFactor = 1.0;
CGFloat const kOGMovementComponentDefaultSpeed = 40;

@interface OGMovementComponent ()

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGAnimationComponent *animationComponent;
@property (nonatomic, strong) OGOrientationComponent *orientationComponent;

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
    
    SKNode *node = self.renderComponent.node;
    OGOrientationComponent *orientationComponent = self.orientationComponent;
    
    OGAnimationState animationState;
    
    
    
    
//    CGVector force = CGVectorMake(kOGMovementComponentDefaultSpeed * self.speedFactor * self.displacementVector.dx,
//                                  kOGMovementComponentDefaultSpeed * self.speedFactor * self.displacementVector.dy);
//    
//    [self.renderComponent.node.physicsBody applyForce:force];
}

@end
