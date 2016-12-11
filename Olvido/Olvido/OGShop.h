//
//  OGShop.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGObstacle.h"

#import "OGInGameShopManager.h"
#import "OGInteractionsManaging.h"

@class OGShopConfiguration;

@interface OGShop : OGSceneItemEntity

@property (nonatomic, weak) id<OGInGameShopManagerProtocol> interactionDelegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 shopConfiguration:(OGShopConfiguration *)shopConfiguration;

@end
