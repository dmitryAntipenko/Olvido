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

@property (nonatomic, strong, readonly) OGRenderComponent *renderComponent;
@property (nonatomic, assign) CGPoint lastPosition;
@property (nonatomic, assign, readonly) CGPoint currentPosition;
@property (nonatomic, strong) UIImage *trailImage;
@property (nonatomic, strong) SKSpriteNode *spriteNode;
@property (nonatomic, assign) CGFloat trailImageVerticalResize;
@property (nonatomic, assign) CGFloat trailImageHorizontalResize;
@property (nonatomic, assign) CGSize trailTextureSize;
@property (nonatomic, strong) UIImage *trailTextureImage;
@property (nonatomic, assign) CGRect accumulatedRect;
@property (nonatomic, assign) CGPoint trailSpriteNodePosition;

@end

@implementation OGTrailComponent

@synthesize  renderComponent = _renderComponent;

- (instancetype)initWithTexture:(SKTexture *)trailTexture size:(CGSize)size
{
    if (trailTexture)
    {
        self = [self init];
        
        if (self)
        {
            _trailImage = [[UIImage alloc] init];
            _trailTextureImage = [UIImage imageWithCGImage:trailTexture.CGImage];
            _spriteNode = [SKSpriteNode spriteNodeWithTexture:trailTexture size:size];
            //            _spriteNode.anchorPoint = CGPointMake(0.0, 0.0);
            _trailTextureSize = size;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

+ (instancetype)trailComponentWithTexture:(SKTexture *)trailTexture  size:(CGSize)size
{
    return [[self alloc] initWithTexture:trailTexture size:size];
}

- (void)updateWithDeltaTime:(NSTimeInterval)seconds
{
    static NSTimeInterval myInterval = 0;
    
    myInterval += seconds;
    
    if (myInterval > 0.5)
    {
        myInterval = 0.0;
        
        CGPoint currentPosition = self.currentPosition;
        
        if (!CGPointEqualToPoint(currentPosition, self.lastPosition))
        {
            [self updateTrail];
            self.lastPosition = currentPosition;
        }
    }
}

- (void)updateTrail
{
    [self updateAccumulatedRect];
    [self updateTrailImage];
    
    self.spriteNode.texture = [SKTexture textureWithImage:self.trailImage];
    self.spriteNode.size = self.trailImage.size;
    self.spriteNode.position = self.trailSpriteNodePosition;
}

- (void)updateTrailImage
{
    CGSize newImageSize = CGSizeMake(self.accumulatedRect.size.width + self.trailTextureSize.width,
                                     self.accumulatedRect.size.height + self.trailTextureSize.height);
    
    CGFloat imageX = 0.0;
    CGFloat imageY = 0.0;
    
    CGFloat newTrailPartX = 0.0;
    CGFloat newTrailPartY = 0.0;
    
    if (self.trailImageHorizontalResize < 0)
    {
        imageX -= self.trailImageHorizontalResize;
    }
    else
    {
        newTrailPartX = self.trailImageHorizontalResize;
    }
    
    if (self.trailImageVerticalResize < 0)
    {
        imageY -= self.trailImageVerticalResize;
    }
    else
    {
        newTrailPartY = self.trailImageVerticalResize;
    }
    
//    UIImageOrientation flippedOrientation = UIImageOrientationUpMirrored;
    self.trailImage = [UIImage imageWithCGImage:self.trailImage.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored];
    
    
    UIGraphicsBeginImageContext(newImageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    UIGraphicsPushContext(context);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    transform = CGAffineTransformTranslate(transform, 0.0f, -(newImageSize.height));
    CGContextConcatCTM(context, transform);
    
    //    [self.trailImage drawInRect:CGRectMake(imageX, imageX, self.trailImage.size.width, self.trailImage.size.height)];
    
    [self.trailImage drawAtPoint:CGPointMake(imageX, imageY)];
    
    [self.trailTextureImage drawInRect:CGRectMake(newTrailPartX,
                                                  newTrailPartY,
                                                  self.trailTextureSize.width,
                                                  self.trailTextureSize.height)];
    //DEBUG//
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)] stroke];
    //    NSLog(@"%@ , %@", NSStringFromCGPoint(self.currentPosition), NSStringFromCGPoint(self.spriteNode.position));
    //    //DEBUG//
    
//    UIGraphicsPopContext();
    
    UIImage *newTrailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.trailImage = newTrailImage;
}

- (void)updateAccumulatedRect
{
    CGPoint currentPosition = self.currentPosition;
    
    CGFloat x = self.accumulatedRect.origin.x;
    CGFloat y = self.accumulatedRect.origin.y;
    CGFloat width = self.accumulatedRect.size.width;
    CGFloat height = self.accumulatedRect.size.height;
    
    self.trailImageHorizontalResize = currentPosition.x - x;
    self.trailImageVerticalResize = currentPosition.y - y;
    
    if (self.trailImageHorizontalResize < 0)
    {
        width -= self.trailImageHorizontalResize;
        x = currentPosition.x;
    }
    else if (self.trailImageHorizontalResize > width)
    {
        width = self.trailImageHorizontalResize;
    }
    
    if (self.trailImageVerticalResize < 0)
    {
        height -= self.trailImageVerticalResize;
        y = currentPosition.y;
    }
    else if (self.trailImageVerticalResize > height)
    {
        height = self.trailImageVerticalResize;
    }
    
    self.trailSpriteNodePosition = CGPointMake(x + width / 2,
                                               y + height / 2);
    
    self.accumulatedRect = CGRectMake(x, y, width, height);
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
    
    self.trailSpriteNodePosition = currentPosition;
    self.accumulatedRect = CGRectMake(currentPosition.x, currentPosition.y, 0.0, 0.0);
    
    self.spriteNode.position = currentPosition;
    self.spriteNode.zPosition = self.renderComponent.node.zPosition - 1;
    [targetNode addChild:self.spriteNode];
}

@end
