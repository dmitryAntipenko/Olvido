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
CGFloat const kOGMovementComponentDefaultSpeed = 40;

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
    
    CGPoint oldPosition = self.renderComponent.node.position;
    CGPoint newPosition = CGPointMake(oldPosition.x + self.displacementVector.dx * self.speedFactor * 5.0,
                                      oldPosition.y + self.displacementVector.dy * self.speedFactor * 5.0);
    
    self.renderComponent.node.position = newPosition;
    
    //CGVector force = CGVectorMake(kOGMovementComponentDefaultSpeed * self.speedFactor * self.displacementVector.dx,
                                  //kOGMovementComponentDefaultSpeed * self.speedFactor * self.displacementVector.dy);
    
    //[self.renderComponent.node.physicsBody applyForce:force];
}

@end
