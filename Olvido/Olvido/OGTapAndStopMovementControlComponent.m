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

NSString *const kOGTapAndStopMovementControlComponentMovingActionKey = @"movingAction";

@interface OGTapAndStopMovementControlComponent ()

@property (nonatomic, assign) CGFloat defaultSpeed;
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@property (nonatomic, assign) OGVisualComponent *visualComponentl;

@end


@implementation OGTapAndStopMovementControlComponent

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode speed:(CGFloat)speed
{
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        _defaultSpeed = speed;
        _targetPoint = CGPointZero;
    }
    
    return self;
}

- (void)touchBeganAtPoint:(CGPoint)point
{
    self.isMooving = YES;
    
    if (self.spriteNode && self.spriteNode.physicsBody)
    {
        self.targetPoint = point;
    }
    
    [self didChangeDirection];
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
