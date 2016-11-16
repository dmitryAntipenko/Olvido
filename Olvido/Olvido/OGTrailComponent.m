//
//  OGTrailComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrailComponent.h"
#import "OGRenderComponent.h"
@interface OGTrailComponent ()

@property (nonatomic, strong) SKTexture *trailTexture;
@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, assign) CGPoint lastPosition;
@property (nonatomic, assign) CGPoint currentPosition;

@end

@implementation OGTrailComponent

@synthesize  renderComponent = _renderComponent;

- (instancetype)initWithTexture:(SKTexture *)trailTexture
{
    if (trailTexture)
    {
        self = [self init];
        
        if (self)
        {
            _trailTexture = trailTexture;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)didAddToEntity
{
    if (self.targetNode)
    {
        self.lastPosition = self.currentPosition;
    }
}

+ (instancetype)trailComponentWithTexture:(SKTexture *)trailTexture
{
    return [[self alloc] initWithTexture:trailTexture];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    if (self.targetNode)
    {
        CGPoint currentPosition = self.currentPosition;
        
        if (!CGPointEqualToPoint(currentPosition, self.lastPosition))
        {
            
        }
    }
}

- (void)drawTrailAtPoint:(CGPoint )point
{
    SKSpriteNode *newNode = 
    [self.targetNode ]
}

- (CGPoint)currentPosition
{
    CGPoint result = CGPointZero;
    
    if (self.targetNode)
    {
        result =  [self.targetNode convertPoint:self.renderComponent.node.position fromNode:self.renderComponent.node.parent];
    }
    
    return result;
}

- (OGRenderComponent *)renderComponent
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _renderComponent = (OGRenderComponent *)[self.entity componentForClass:OGRenderComponent.self];
    });
    
    return _renderComponent;
}

@end
