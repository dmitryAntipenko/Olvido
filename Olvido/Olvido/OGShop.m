

//
//  OGShop.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShop.h"
#import "OGPlayerEntity.h"

#import "OGContactNotifiableType.h"
#import "OGShopConfiguration.h"
#import "OGShopItemConfiguration.h"

@interface OGShop ()

@property (nonatomic, strong) NSArray<OGShopItemConfiguration *> *shopItemsConfiguration;
@property (nonatomic, copy) NSString *identifier;

@end

@implementation OGShop

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                 shopConfiguration:(OGShopConfiguration *)shopConfiguration
{
    if (sprite)
    {
        self = [super initWithSpriteNode:sprite];
        
        if (self)
        {
            _identifier = shopConfiguration.identifier;
            _shopItemsConfiguration = shopConfiguration.shopItemsConfiguration;
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        [self.interactionDelegate showWithShopItems:self.shopItemsConfiguration player:(OGPlayerEntity *)entity];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

@end
