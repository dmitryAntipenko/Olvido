

//
//  OGShop.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGShop.h"
#import "OGPlayerEntity.h"

#import "OGPhysicsComponent.h"

#import "OGShopConfiguration.h"
#import "OGShopItemConfiguration.h"

@interface OGShop ()

@property (nonatomic, strong) NSArray<OGShopItemConfiguration *> *shopItemsConfiguration;
@property (nonatomic, copy) NSString *identifier;

@end

@implementation OGShop

- (instancetype)initWithSpriteNode:(SKSpriteNode *)spriteNode
                 shopConfiguration:(OGShopConfiguration *)shopConfiguration
{
    spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.size];
    self = [super initWithSpriteNode:spriteNode];
    
    if (self)
    {
        self.physicsComponent.physicsBody.categoryBitMask = [OGColliderType obstacle].categoryBitMask;
        self.physicsComponent.physicsBody.dynamic = NO;
        
        NSArray *contactColliders = @[[OGColliderType player]];
        [[OGColliderType requestedContactNotifications] setObject:contactColliders forKey:[OGColliderType obstacle]];
        
        _identifier = shopConfiguration.identifier;
        _shopItemsConfiguration = shopConfiguration.shopItemsConfiguration;
    }

    return self;
}

- (void)contactWithEntityDidBegin:(GKEntity *)entity
{
    [super contactWithEntityDidBegin:entity];
    
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        self.interactionDelegate.visitor = (id<OGSceneItemsDelegate>) entity;
        [self.interactionDelegate showShopButtonWithIdentifier:self.identifier
                                                     shopItems:self.shopItemsConfiguration];
    }
}

- (void)contactWithEntityDidEnd:(GKEntity *)entity
{
    [super contactWithEntityDidEnd:entity];
    
    if ([entity isMemberOfClass:[OGPlayerEntity class]])
    {
        self.interactionDelegate.visitor = nil;
        
        [self.interactionDelegate hideShopButtonWithIdentifier:self.identifier];
    }
}

@end
