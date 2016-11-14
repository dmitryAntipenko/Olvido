//
//  OGInventoryObserver.h
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGInventoryObserver <NSObject>

- (void)inventoryDidUpdate;

@end
