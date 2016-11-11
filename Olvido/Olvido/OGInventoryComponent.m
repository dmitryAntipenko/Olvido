//
//  OGInventoryComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryComponent.h"

NSUInteger const kOGInventoryComponentDefaultCapacity = 5;

@interface OGInventoryComponent ()

@property (nonatomic, unsafe_unretained, readonly, getter=isFull) BOOL full;
@property (nonatomic, strong) NSMutableArray<id <OGInventoryItem>> *mutableInventoryItems;

@end

@implementation OGInventoryComponent

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    
    if (self)
    {
        _capacity = capacity;
        _mutableInventoryItems = [NSMutableArray arrayWithCapacity:capacity];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithCapacity:kOGInventoryComponentDefaultCapacity];
}

- (void)didAddToEntity
{

}

- (void)addItem:(id <OGInventoryItem>)item
{
    if (item)
    {
        if (!self.isFull)
        {
            [self.mutableInventoryItems addObject:item];
            [item didTaken];
        }
        else
        {
            //do some
        }
    }
}

- (void)removeItem:(id <OGInventoryItem>)item
{
    if (item && [self.mutableInventoryItems containsObject:item])
    {
        [self.mutableInventoryItems removeObject:item];
        [item didThrown];
    }
}

- (BOOL)isFull
{
    return self.mutableInventoryItems.count < self.capacity;
}

- (NSArray<id<OGInventoryItem>> *)inventoryItems
{
    return [self.mutableInventoryItems copy];
}

@end
