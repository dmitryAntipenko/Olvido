//
//  OGInventory.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventory.h"

@interface OGInventory ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id<OGInventoryItemProtocol>> *mutableItems;

@end

@implementation OGInventory

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableItems = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSArray<id<OGInventoryItemProtocol>> *)items
{
    return _mutableItems.allValues;
}

- (void)addItem:(id<OGInventoryItemProtocol>)item
{
    [self.mutableItems setObject:item forKey:[item inventoryIdentifier]];
}

- (void)removeItem:(id<OGInventoryItemProtocol>)item
{
    [self.mutableItems removeObjectForKey:[item inventoryIdentifier]];
}

- (id<OGInventoryItemProtocol>)findItemWithIdentifier:(NSString *)identifier
{
    return self.mutableItems[identifier];
}

@end
