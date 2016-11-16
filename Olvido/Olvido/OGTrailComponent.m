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
@property (nonatomic, strong) UIImage *trail;

@property (nonatomic, assign) CGRect trailAccumulatedRect;

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
            _trail = [[UIImage alloc] init];
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

- (void)calculateAccumulatedrectWithCurrentPosition:(CGPoint)currentPosition
{
    if (!CGRectContainsPoint(self.trailAccumulatedRect, currentPosition))
    {
        CGFloat x = self.trailAccumulatedRect.origin.x;
        CGFloat y = self.trailAccumulatedRect.origin.y;
        CGFloat width = self.trailAccumulatedRect.size.width;
        CGFloat height = self.trailAccumulatedRect.size.height;
        
        if (currentPosition.x < x)
        {
            width += x - currentPosition.x;
            x = currentPosition.x;
        }
        else if (currentPosition.x > x + width)
        {
            width = currentPosition.x - x;
        }
        
        if (currentPosition.y < y)
        {
            height += y - currentPosition.y;
            y = currentPosition.y;
        }
        else if (currentPosition.y > y + height)
        {
            height = currentPosition.y - y;
        }
        
        
        
        self.trailAccumulatedRect = CGRectMake(x, y, width, height);
    }
}

+ (instancetype)trailComponentWithTexture:(SKTexture *)trailTexture
{
    return [[self alloc] initWithTexture:trailTexture];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    CGPoint currentPosition = self.currentPosition;
    
    if (!CGPointEqualToPoint(currentPosition, self.lastPosition))
    {
        [self drawTrailAtPoint:currentPosition];
        self.lastPosition = currentPosition;
    }
}

- (void)drawTrailAtPoint:(CGPoint )point
{
    SKSpriteNode *newNode = [SKSpriteNode spriteNodeWithTexture:self.trailTexture size:CGSizeMake(64, 64)];
    newNode.position = point;
    newNode.zPosition = self.renderComponent.node.zPosition - 1;
    
    UIGraphicsBeginImageContext(CGSizeMake(256, 256));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[SKColor yellowColor] setFill];
    CGContextFillEllipseInRect(ctx, CGRectMake(64, 64, 128, 128));
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    SKTexture *texture = [SKTexture textureWithImage:textureImage];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
    
    [self addChild:sprite];
    
    UIImage *image = UIIMage
    
    [self.targetNode addChild:newNode];
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
