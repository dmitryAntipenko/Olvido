//
//  OGInventoryComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInventoryItem.h"

@protocol OGInventoryComponentDelegate <NSObject>

- (void)inventoryDidUpdate;

@end

extern NSString *const kOGInventoryComponentInventoryItemsKeyPath;

@interface OGInventoryComponent : GKComponent

@property (nonatomic, assign, readonly, getter=isFull) BOOL full;
@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;
@property (nonatomic, assign, readonly) NSUInteger capacity;
@property (nonatomic, strong, readonly) NSArray<id <OGInventoryItem>> *inventoryItems;
@property (nonatomic, weak) id <OGInventoryComponentDelegate> inventoryComponentDelegate;

+ (instancetype)inventoryComponentWithCapacity:(NSUInteger)capacity;
+ (instancetype)inventoryComponent;

- (void)addItem:(id <OGInventoryItem>)item;
- (void)removeItem:(id <OGInventoryItem>)item;

- (BOOL)containsItem:(id <OGInventoryItem>)item;
- (BOOL)containsItemWithIdentifier:(NSString *)identifier;

- (BOOL)isFull;
- (BOOL)isEmpty;

@end
