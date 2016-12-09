//
//  OGShop.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInteractionsManaging.h"
#import "OGObstacle.h"
#import "OGInGameShopManager.h"

@class OGShopConfiguration;


@interface OGShop : OGObstacle

@property (nonatomic, weak) id<OGInGameShopManagerProtocol> interactionDelegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
                 shopConfiguration:(OGShopConfiguration *)shopConfiguration;

@end
