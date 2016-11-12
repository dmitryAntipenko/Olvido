//
//  OGInventory.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventory.h"

@interface OGInventory ()

@property (nonatomic, strong) NSMutableArray<id<OGInventoryItemProtocol>> *mutableItems;

@end

@implementation OGInventory

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray<id<OGInventoryItemProtocol>> *)items
{
    return _mutableItems;
}

- (void)addItem:(id<OGInventoryItemProtocol>)item
{
    [self.mutableItems addObject:item];
}

- (void)removeItem:(id<OGInventoryItemProtocol>)item
{
    [self.mutableItems removeObject:item];
}

@end
