//
//  OGTapAndStopMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapAndStopMovementControlComponent.h"

NSString *const kOGTapAndStopMovementControlComponentMovingActionKey = @"movingAction";

@interface OGTapAndStopMovementControlComponent ()

@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@property (nonatomic, assign) CGFloat pausedSpeedFactor;

@end

@implementation OGTapAndStopMovementControlComponent

- (void)didAddToEntity
{
    self.pausedSpeedFactor = kOGMovementControlComponentDefaultSpeedFactor;
    
    [super didAddToEntity];
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    self.isMooving = YES;
    
    if (self.node)
    {
        self.targetPoint = point;
        
        [self moveToPoint:point];
    }
}

- (void)moveToPoint:(CGPoint)point
{
    if (self.node)
    {
        [self.node removeActionForKey:kOGTapAndStopMovementControlComponentMovingActionKey];
        
        CGFloat distance = hypot(self.node.position.x - point.x, self.node.position.y - point.y);
        
        CGFloat timeDuration = distance / (self.speedFactor * self.defaultSpeed);
        
        SKAction *movingAction = [SKAction moveTo:point duration:timeDuration];
        
        [self.node runAction:movingAction withKey:kOGTapAndStopMovementControlComponentMovingActionKey];
    }
}

- (void)setSpeedFactor:(CGFloat)speedFactor
{
    [super setSpeedFactor:speedFactor];
    
    if (self.isMooving)
    {
        [self moveToPoint:self.targetPoint];
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
