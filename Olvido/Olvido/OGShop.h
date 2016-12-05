//
//  OGShop.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInteractionsManaging.h"

@class OGShopConfiguration;

@interface OGShop : GKEntity

@property (nonatomic, weak) id<OGInteractionsManaging> delegate;
@property (nonatomic, strong, readonly) OGShopConfiguration *shopConfiguration;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                 shopConfiguration:(OGShopConfiguration *)shopConfiguration;

@end
