//
//  OGTrailComponent.m
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGTrailComponent.h"
#import "OGRenderComponent.h"



typedef NS_ENUM(NSUInteger, OGTrailComponentImageVerticalAligment)
{
    kOGTrailComponentImageAligmentTop = 0x00 << 0,
    kOGTrailComponentImageAligmentBottom = 0x01 << 0
};

typedef NS_ENUM(NSUInteger, OGTrailComponentImageHorizontalAligment)
{
    kOGTrailComponentImageAligmentLeft = 0x00 << 1,
    kOGTrailComponentImageAligmentRight = 0x01 << 1
};

@interface OGTrailComponent ()

@property (nonatomic, strong) SKTexture *trailTexture;
@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, assign) CGPoint lastPosition;
@property (nonatomic, assign) CGPoint currentPosition;
@property (nonatomic, strong) UIImage *trailImage;
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, assign) OGTrailComponentImageVerticalAligment trailImageVerticalAligment;
@property (nonatomic, assign) OGTrailComponentImageHorizontalAligment trailImageHorizontalAligment;
@property (nonatomic, assign) CGSize trailTextureSize;

@property (nonatomic, assign) CGRect accumulatedRect;

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
            _trailImage = [[UIImage alloc] init];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
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
    
    [self updateAccumulatedrectWithCurrentPosition];
    [self updateTrailImage];
    
//    [self addChild:sprite];
//    
//    UIImage *image = UIIMage
//    
//    [self.targetNode addChild:newNode];
}

- (void)updateTrailImage
{
    UIGraphicsBeginImageContext(CGSizeMake(self.accumulatedRect.size.width + self.trailTexture.size.width,
                                           self.accumulatedRect.size.height + self.trailTexture.size.height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    
    if (self.trailImageHorizontalAligment == kOGTrailComponentImageAligmentRight)
    {
        imageX = self.accumulatedRect.size.width - self.trailImage.size.width;
    }
    
    if (self.trailImageVerticalAligment == kOGTrailComponentImageAligmentTop)
    {
        imageY = self.accumulatedRect.size.height - self.trailImage.size.height;
    }
    
    [self.trailImage drawAtPoint:CGPointMake(imageX, imageY)];
    CGContextDrawImage(ctx, self.trailTextureSize, self.trailTexture.CGImage);//size texture have to be configured
    
    UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
}

- (void)updateAccumulatedrectWithCurrentPosition
{
    CGPoint currentPosition = self.currentPosition;
    
    if (!CGRectContainsPoint(self.accumulatedRect, currentPosition))
    {
        CGFloat x = self.accumulatedRect.origin.x;
        CGFloat y = self.accumulatedRect.origin.y;
        CGFloat width = self.accumulatedRect.size.width;
        CGFloat height = self.accumulatedRect.size.height;
        
        if (currentPosition.x < x)
        {
            width += x - currentPosition.x;
            x = currentPosition.x;
            
            self.trailImageHorizontalAligment = kOGTrailComponentImageAligmentLeft;
        }
        else if (currentPosition.x > x + width)
        {
            width = currentPosition.x - x;
            
            self.trailImageHorizontalAligment = kOGTrailComponentImageAligmentLeft;
        }
        
        if (currentPosition.y < y)
        {
            height += y - currentPosition.y;
            y = currentPosition.y;
            
            self.trailImageVerticalAligment = kOGTrailComponentImageAligmentBottom;
        }
        else if (currentPosition.y > y + height)
        {
            height = currentPosition.y - y;
        
            self.trailImageVerticalAligment = kOGTrailComponentImageAligmentTop;
        }
        
        self.accumulatedRect = CGRectMake(x, y, width, height);
    }
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
    if (!_renderComponent)
    {
        _renderComponent = (OGRenderComponent *)[self.entity componentForClass:OGRenderComponent.self];
    }
    
    return _renderComponent;
}

- (void)setTargetNode:(SKNode *)targetNode
{
    _targetNode = targetNode;
    
    CGPoint currentPosition = self.currentPosition;
    self.accumulatedRect = CGRectMake(currentPosition.x, currentPosition.y, 0.0, 0.0);
}

@end
