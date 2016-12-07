//
//  OGInGameShopManager.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGInteractionsManaging.h"

@class OGShopItemConfiguration;
@class OGPlayerEntity;

@protocol OGInGameShopManagerProtocol <NSObject>

- (void)showWithShopItems:(NSArray<OGShopItemConfiguration *> *)shopItems player:(OGPlayerEntity *)player;

@end

@interface OGInGameShopManager : NSObject <OGInGameShopManagerProtocol>

@property (nonatomic, weak) id<OGInteractionsManaging> delegate;

@end
