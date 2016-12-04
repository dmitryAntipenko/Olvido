

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

@interface OGShop () <OGContactNotifiableType>

@property (nonatomic, strong) OGRenderComponent *renderComponent;
@property (nonatomic, strong) OGPhysicsComponent *physicsComponent;

@end

@implementation OGShop


- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite
{
    if (sprite)
    {
        self = [super init];
        
        if (self)
        {
            NSArray *contactColliders = @[[OGColliderType player]];
            [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType shop]];
            
            _renderComponent = [[OGRenderComponent alloc] init];
            _renderComponent.node = sprite;
            [self addComponent:_renderComponent];
            
            _physicsComponent = [[OGPhysicsComponent alloc] initWithPhysicsBody:sprite.physicsBody
                                                                   colliderType:[OGColliderType shop]];
            [self addComponent:_physicsComponent];
        }
    }
    else
    {
        self = nil;
    }
    
    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        [self.delegate showShop];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
}

@end
