//
//  OGInventoryBarNode.m
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryBarNode.h"
#import "OGInventoryComponent.h"
#import "OGZPositionEnum.m"
#import "OGRenderComponent.h"

CGFloat const kOGInventoryBarNodeMaxHeight = 256;
CGFloat const kOGInventoryBarNodeMaxWidthFactor = 0.5;
CGFloat const kOGInventoryBarNodeDesiredHeightFactor = 0.0625;
CGFloat const kOGInventoryBarNodeDefaultXPosition = 0.0;
CGFloat const kOGInventoryBarNodeDefaultItemNodeYPosition = 0.0;

@interface OGInventoryBarNode ()

@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;
@property (nonatomic, unsafe_unretained) CGSize itemSize;

@end

@implementation OGInventoryBarNode

- (instancetype)initWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    CGSize defaultSize = CGSizeMake(768, 256);
    
    self = [self initWithColor:[[SKColor lightGrayColor] colorWithAlphaComponent:0.5] size:defaultSize];
    
    if (self)
    {
        _inventoryComponent = inventoryComponent;
    }
    
    return self;
}

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    return [[self alloc] initWithInventoryComponent:inventoryComponent];
}

- (void)update
{
    CGSize frameSize = CGSizeZero;
    
    if (self.scene)
    {
        frameSize = self.scene.frame.size;
    }
    
    CGFloat height = frameSize.height * kOGInventoryBarNodeDesiredHeightFactor;
    
    if (height > kOGInventoryBarNodeMaxHeight)
    {
        height = kOGInventoryBarNodeMaxHeight;
    }
    
    CGFloat width = height * self.inventoryComponent.capacity;
    
    CGFloat widthWithFactor = frameSize.width * kOGInventoryBarNodeMaxWidthFactor;
    
    if (width > widthWithFactor)
    {
        width = widthWithFactor;
        height = widthWithFactor / self.inventoryComponent.capacity;
    }
    
    self.size = CGSizeMake(width, height);
    self.position = CGPointMake(kOGInventoryBarNodeDefaultXPosition, (height - frameSize.height) / 2);
    self.zPosition = OGZPositionCategoryForeground;
    
    self.itemSize = CGSizeMake(height, height);
    [self updateItems];
}

- (void)updateItems
{
    [self removeAllChildren];
    
    if (self.inventoryComponent)
    {
        
        __weak typeof(self) weakSelf = self;
        
        [self.inventoryComponent.inventoryItems enumerateObjectsUsingBlock:^(id<OGInventoryItem> item, NSUInteger idx, BOOL * _Nonnull stop)
        {
            if (weakSelf)
            {
                typeof(weakSelf) strongSelf = weakSelf;
                
                SKNode *itemNode = [SKSpriteNode spriteNodeWithTexture:item.texture size:strongSelf.itemSize];
                CGFloat xPosition = (self.itemSize.width - self.size.width ) / 2 + self.itemSize.width * idx;
                itemNode.position = CGPointMake(xPosition, kOGInventoryBarNodeDefaultItemNodeYPosition);
                
                [strongSelf addChild:itemNode];
            }
        }];
    }
}

@end
