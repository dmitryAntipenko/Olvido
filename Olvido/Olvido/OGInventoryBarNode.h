//
//  OGInventoryBarNode.h
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGInventoryComponent;

@interface OGInventoryBarNode : SKSpriteNode

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent;

- (void)update;

@end
