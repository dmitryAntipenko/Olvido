

//
//  OGShop.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShop.h"
#import "OGPlayerEntity.h"

#import "OGContactNotifiableType.h"

#import "OGRenderComponent.h"
#import "OGPhysicsComponent.h"

@implementation OGShop

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        [self.interactionDelegate showShop];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

@end
