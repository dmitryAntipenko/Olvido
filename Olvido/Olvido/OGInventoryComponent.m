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
#import "OGSceneItemEntity.h"

NSString *const OGInventoryComponentInventoryItemsKeyPath = @"inventoryItems";
NSUInteger const OGInventoryComponentDefaultCapacity = 7;
NSUInteger const OGInventoryComponentEmptyCount = 0;

@interface OGInventoryComponent ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, id <OGInventoryItem>> *mutableInventoryItems;

@end

@implementation OGInventoryComponent

#pragma mark - Initializing

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
    return [self initWithCapacity:OGInventoryComponentDefaultCapacity];
}

#pragma mark - Inventory Managing

- (void)addItem:(id<OGInventoryItem>)item
{
    if (item)
    {
        if (!self.isFull)
        {
            [self.mutableInventoryItems setObject:item forKey:item.identifier];
            
            if ([item isKindOfClass:[OGSceneItemEntity class]])
            {
                ((OGSceneItemEntity *) item).delegate = self;
            }
            
            if ([item respondsToSelector:@selector(wasTaken)])
            {
                [item wasTaken];
            }
            
            [self.inventoryComponentDelegate inventoryDidUpdate];
        }
    }
}

- (void)removeItem:(id<OGInventoryItem>)item
{
    if (item && [self.mutableInventoryItems objectForKey:item.identifier])
    {
        [self.mutableInventoryItems removeObjectForKey:item.identifier];
        
        if ([item respondsToSelector:@selector(didThrown)])
        {
            [item didThrown];
        }
        
        [self.inventoryComponentDelegate inventoryDidUpdate];
    }
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
    return self.mutableInventoryItems.count == OGInventoryComponentEmptyCount;
}

#pragma mark - OGEntityManaging

- (void)addEntity:(GKEntity *)entity
{
    [self addItem:(id<OGInventoryItem>) entity];
}

- (void)removeEntity:(GKEntity *)entity
{
    [self removeItem:(id<OGInventoryItem>) entity];
}

#pragma mark - Getters

- (NSArray<id<OGInventoryItem>> *)inventoryItems
{
    return self.mutableInventoryItems.allValues;
}

@end
