//
//  OGHUDNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGHUDNode.h"
#import "OGZPositionEnum.h"

@interface OGHUDNode ()

@property (nonatomic, strong) NSMutableArray<id<OGHUDElement>> *mutableHudElements;

@end

@implementation OGHUDNode

#pragma mark - Initializing

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _mutableHudElements = [NSMutableArray array];
        self.zPosition = OGZPositionCategoryForeground;
    }
    
    return self;
}

- (void)addHUDElement:(id<OGHUDElement>)element
{
    if (element)
    {
        [self.mutableHudElements addObject:element];
        [self addChild:(SKNode *) element];
        element.hudNode = self;
        [element didAddToHUD];
    }
}

- (void)removeHUDElement:(id<OGHUDElement>)element
{
    if (element)
    {
        [self.mutableHudElements removeObject:element];
        element.hudNode = nil;
        [((SKNode *) element) removeFromParent];
    }
}

#pragma mark - Update

- (void)updateHUD
{
    for (id<OGHUDElement> element in self.mutableHudElements)
    {
        [element update];
    }
}

#pragma mark - Getters

- (NSArray<id<OGHUDElement>> *)hudElements
{
    return self.mutableHudElements;
}

@end
