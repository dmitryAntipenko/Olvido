//
//  OGInGameShopManager.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGInteractionsManaging.h"
#import "OGSceneItemEntity.h"

@class OGShopItemConfiguration;
@class OGPlayerEntity;

@protocol OGInGameShopManagerProtocol <NSObject>

- (void)showWithShopItems:(NSArray<OGShopItemConfiguration *> *)shopItems;

@property (nonatomic, weak) id<OGSceneItemsDelegate> visitor;

@end

@interface OGInGameShopManager : NSObject <OGInGameShopManagerProtocol>

@property (nonatomic, weak) id<OGInteractionsManaging, OGEntityManaging> delegate;
@property (nonatomic, weak) id<OGSceneItemsDelegate> visitor;

@end
