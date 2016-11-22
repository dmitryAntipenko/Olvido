//
//  OGRenderComponent.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGRenderComponent.h"
#import "OGZPositionEnum.m"

@implementation OGRenderComponent

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _node = [[SKNode alloc] init];
    }
    
    return self;
}

- (void)didAddToEntity
{
    [super didAddToEntity];
    
    self.node.entity = self.entity;
    self.node.zPosition = OGZPositionCategoryPhysicsWorld;
}

- (void)willRemoveFromEntity
{
    [super willRemoveFromEntity];
    
    self.node.entity = nil;
}

@end
