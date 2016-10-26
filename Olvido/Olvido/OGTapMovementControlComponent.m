//
//  OGTapMovementControlComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTapMovementControlComponent.h"
#import "OGVisualComponent.h"
#import "OGSpriteNode.h"

@interface OGTapMovementControlComponent ()

@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL isMooving;

@end

@implementation OGTapMovementControlComponent

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
    GKSKNodeComponent *nodeComponent = (GKSKNodeComponent *) [self.entity componentForClass:[GKSKNodeComponent class]];
    SKSpriteNode *spriteNode = (SKSpriteNode *) nodeComponent.node;
    
    if (spriteNode && spriteNode.physicsBody)
    {
        self.targetPoint = point;
        CGVector displacementVector = CGVectorMake(point.x - spriteNode.position.x,
                                                   point.y - spriteNode.position.y);
        
        CGFloat displacement = hypot(displacementVector.dx, displacementVector.dy);
        
        CGFloat speedX = displacementVector.dx / displacement * self.speedFactor * self.defaultSpeed;
        
        CGFloat speedY = displacementVector.dy / displacement * self.speedFactor * self.defaultSpeed;
        
        spriteNode.physicsBody.velocity = CGVectorMake(speedX, speedY);
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
