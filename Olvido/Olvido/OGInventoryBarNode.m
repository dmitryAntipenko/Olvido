//
//  OGInventoryBarNode.m
//  Olvido
//
//  Created by Алексей Подолян on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInventoryBarNode.h"
#import "OGInventoryComponent.h"



@interface OGInventoryBarNode ()

@property (nonatomic, strong) OGInventoryComponent *inventoryComponent;

@end

@implementation OGInventoryBarNode

- (instancetype)initWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    CGSize defaultSize = CGSizeMake(256, 256);
    
    self = [self initWithColor:[[SKColor lightGrayColor] colorWithAlphaComponent:0.5] size:defaultSize];
    
    if (self)
    {
        _inventoryComponent = inventoryComponent;
    }
    
    return self;
}

+ (instancetype)inventoryBarNodeWithInventoryComponent:(OGInventoryComponent *)inventoryComponent
{
    return [[self alloc] initWithInventoryComponent:inventoryComponent];
}

@end
