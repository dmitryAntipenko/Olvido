//
//  OGInventoryBarNode.h
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGHUDElement.h"

@class OGInventoryComponent;
@class OGPlayerEntity;

@interface OGInventoryBarNode : SKSpriteNode <OGHUDElement>

@property (nonatomic, weak) OGHUDNode *hudNode;

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent;

- (void)updateConstraints;

- (void)checkPlayerPosition;

@end
