//
//  OGTapMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapMovementControlComponent.h"

@interface OGTapMovementControlComponent ()

@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@property (nonatomic, assign) CGFloat pausedSpeedFactor;

@end

@implementation OGTapMovementControlComponent

- (void)didAddToEntity
{
    self.pausedSpeedFactor = kOGMovementControlComponentDefaultSpeedFactor;
    
    [super didAddToEntity];
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    self.isMooving = YES;
    
    [self moveToPoint:point];
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    [super setSpeedFactor:speedFactor];
    
    if (self.isMooving)
    {
        [self moveToPoint:self.targetPoint];
    }
}

- (void)moveToPoint:(CGPoint)point
{
    if (self.node && self.node.physicsBody)
    {
        self.targetPoint = point;
        CGVector displacementVector = CGVectorMake(point.x - self.node.position.x,
                                                   point.y - self.node.position.y);
        
        CGFloat displacement = hypot(displacementVector.dx, displacementVector.dy);
        
        CGFloat speedX = displacementVector.dx / displacement * self.speedFactor * self.defaultSpeed;
        
        CGFloat speedY = displacementVector.dy / displacement * self.speedFactor * self.defaultSpeed;
        
        self.node.physicsBody.velocity = CGVectorMake(speedX, speedY);
    }
}

- (void)pause
{
    self.pausedSpeedFactor = self.speedFactor;
    self.speedFactor = 0.0;
}

- (void)resume
{
    self.speedFactor = self.pausedSpeedFactor;
}


@end
