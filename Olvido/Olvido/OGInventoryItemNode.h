//
//  OGInventoryItemNode.h
//  Olvido
//
//  Created by Алексей Подолян on 12/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGButtonNode.h"
#import "OGInventoryItem.h"

@interface OGInventoryItemNode : OGButtonNode

+ (instancetype)itemNodeWithItem:(id<OGInventoryItem>)item size:(CGSize)size;

@end
