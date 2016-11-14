//
//  OGInventoryComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInventoryItem.h"

@interface OGInventoryComponent : GKComponent

@property (nonatomic, unsafe_unretained, readonly) NSUInteger capacity;
@property (nonatomic, strong, readonly) NSArray<id <OGInventoryItem>> *inventoryItems;

+ (instancetype)inventoryComponentWithCapacity:(NSUInteger)capacity;

+ (instancetype)inventoryComponent;

- (void)addItem:(id <OGInventoryItem>)item;

- (void)removeItem:(id <OGInventoryItem>)item;

- (BOOL)containsItem:(id <OGInventoryItem>)item;

- (BOOL)isFull;

@end
