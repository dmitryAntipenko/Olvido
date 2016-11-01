//
//  OGInventoryComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryComponent.h"
#import "OGSpriteNode.h"

NSUInteger const kOGInventoryComponentDefaultCapacity = 5;

@interface OGInventoryComponent ()

@property (nonatomic, strong, readwrite) NSMutableArray<OGSpriteNode *> *mutableInventory;

@end

@implementation OGInventoryComponent

- (void)didAddToEntity
{
    NSMutableArray *inventory = [[NSMutableArray alloc] init];
    self.mutableInventory = inventory;
    
    self.capacity = kOGInventoryComponentDefaultCapacity;
}

- (void)addItem:(OGSpriteNode *)item
{
    if (self.mutableInventory.count < self.capacity && item)
    {
        [self.mutableInventory addObject:item];
    }
}

- (void)removeItem:(OGSpriteNode *)item
{
    if (item)
    {
        [self.mutableInventory removeObject:item];
    }
}

- (NSArray<OGSpriteNode *> *)inventory
{
    return [self.mutableInventory copy];
}


@end
