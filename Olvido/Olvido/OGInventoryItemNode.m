//
//  OGInventoryItemNode.m
//  Olvido
//
//  Created by Алексей Подолян on 12/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryItemNode.h"
#import "OGZPositionEnum.h"

@interface OGInventoryItemNode ()

@property (nonatomic, strong) id<OGInventoryItem> item;

@end

@implementation OGInventoryItemNode

+ (instancetype)itemNodeWithItem:(id<OGInventoryItem>)item size:(CGSize)size
{
    OGInventoryItemNode *result = nil;
    
    if (item && size.width > 0.0 && size.height > 0.0)
    {
        SKTexture *itemTexture = item.texture;
        
        CGSize itemSize = CGSizeZero;
        
        CGFloat sizeWidthHeightFactor = size.width / size.height;
        CGFloat widthHeightFactor = itemTexture.size.width / itemTexture.size.height;
        
        if (widthHeightFactor > sizeWidthHeightFactor)
        {
            itemSize = CGSizeMake(size.width, size.height / widthHeightFactor);
        }
        else
        {
            itemSize = CGSizeMake(size.width * widthHeightFactor, size.height);
        }
        
        result = [self spriteNodeWithTexture:itemTexture size:itemSize];
        result.item = item;
    }
    
    return result;
}

- (void)doAction
{
    if ([self.item respondsToSelector:@selector(wasSelected)])
    {
        [self.item wasSelected];
    }
}

@end
