//
//  OGTapAndStopMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapAndStopMovementControlComponent.h"
#import "OGVisualComponent.h"
#import "OGSpriteNode.h"

CGFloat const kOGTapAndStopMovementControlComponentDefaultSpeed = 500;
NSString *const kOGTapAndStopMovementControlComponentMovingActionKey = @"movingAction";

@interface OGTapAndStopMovementControlComponent ()

@property (nonatomic, assign) CGFloat defaultSpeed;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@end

@implementation OGTapAndStopMovementControlComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _defaultSpeed = kOGTapAndStopMovementControlComponentDefaultSpeed;
    }
    
    return self;
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    self.isMooving = YES;
    
    if (self.visualComponent)
    {
        self.targetPoint = point;
        
        [self moveToPoint:point];
    }
}

- (void)moveToPoint:(CGPoint)point
{
    if (self.visualComponent)
    {
        [self.visualComponent.spriteNode removeActionForKey:kOGTapAndStopMovementControlComponentMovingActionKey];
        
        CGFloat distance = hypot(self.visualComponent.spriteNode.position.x - point.x, self.visualComponent.spriteNode.position.y);
        
        CGFloat timeDuration = distance / (self.speedFactor * self.defaultSpeed);
        
        SKAction *movingAction = [SKAction moveTo:point duration:timeDuration];
        
        [self.visualComponent.spriteNode runAction:movingAction withKey:kOGTapAndStopMovementControlComponentMovingActionKey];
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

- (void)stop
{
    self.speedFactor = 0.0;
}

- (void)dealloc
{
    [super dealloc];
}


@end
