//
//  OGInventoryComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryComponent.h"
#import "OGMessageComponent.h"
#import "OGRenderComponent.h"

NSString *const kOGInventoryComponentInventoryItemsKeyPath = @"inventoryItems";
NSUInteger const kOGInventoryComponentDefaultCapacity = 5;
NSUInteger const kOGInventoryComponentEmptyCount = 0;

@interface OGInventoryComponent ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id <OGInventoryItem>> *mutableInventoryItems;

@end

@implementation OGInventoryComponent

+ (instancetype)inventoryComponentWithCapacity:(NSUInteger)capacity
{
    return [[self alloc] initWithCapacity:capacity];
}

+ (instancetype)inventoryComponent
{
    return [[self alloc] init];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
            
    if (self)
    {
        _capacity = capacity;
        _mutableInventoryItems = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithCapacity:kOGInventoryComponentDefaultCapacity];
}

- (void)addItem:(id <OGInventoryItem>)item
{
    [self willChangeValueForKey:kOGInventoryComponentInventoryItemsKeyPath];
    
    if (item)
    {
        if (!self.isFull)
        {
            [self.mutableInventoryItems setObject:item forKey:item.identifier];
            
            if ([item respondsToSelector:@selector(didTaken)])
            {
                [item didTaken];
            }
        }
    }
    
    [self didChangeValueForKey:kOGInventoryComponentInventoryItemsKeyPath];
}

- (void)removeItem:(id <OGInventoryItem>)item
{
    [self willChangeValueForKey:kOGInventoryComponentInventoryItemsKeyPath];
    
    if (item && [self.mutableInventoryItems objectForKey:item.identifier])
    {
        [self.mutableInventoryItems removeObjectForKey:item.identifier];
        
        if ([item respondsToSelector:@selector(didThrown)])
        {
            [item didThrown];
        }
    }
    
    [self didChangeValueForKey:kOGInventoryComponentInventoryItemsKeyPath];
}

- (BOOL)containsItem:(id <OGInventoryItem>)item
{
    BOOL result = NO;
    
    if (item)
    {
        result = [self.mutableInventoryItems objectForKey:item.identifier] != nil;
    }
    
    return result;
}

- (BOOL)containsItemWithIdentifier:(NSString *)identifier
{
    return self.mutableInventoryItems[identifier] != nil;
}

- (BOOL)isFull
{
    return self.mutableInventoryItems.count >= self.capacity;
}

- (BOOL)isEmpty
{
    return self.mutableInventoryItems.count == kOGInventoryComponentEmptyCount;
}

- (NSArray<id<OGInventoryItem>> *)inventoryItems
{
    return self.mutableInventoryItems.allValues;
}

@end
