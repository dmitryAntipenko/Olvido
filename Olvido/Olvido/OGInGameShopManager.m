//
//  OGInGameShopManager.m
//  Olvido
//
//  Created by Александр Песоцкий on 12/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInGameShopManager.h"
#import "OGZPositionEnum.h"
#import "OGShopItemConfiguration.h"
#import "OGButtonNode.h"
#import "OGPlayerEntity.h"
#import "OGShootingWeapon.h"
#import "OGInventoryItem.h"

NSString *const OGInGameShopManagerShopScreenNodeName = @"OGShopScreen.sks";
NSString *const OGInGameShopManagerBuyItem = @"BuyItem";
NSString *const OGInGameShopManagerTexture = @"Texture";
NSString *const OGInGameShopManagerPrice = @"Price";

NSString *const OGInGameShopManagerResumeButtonName = @"ResumeFromShopButton";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitConfiguration = @"UnitConfiguration";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitClass = @"UnitClass";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitConfigurationClass = @"UnitConfigurationClass";


@interface OGInGameShopManager ()

@property (nonatomic, strong) SKReferenceNode *shopScreenNode;

@end

@implementation OGInGameShopManager

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _shopScreenNode = [[SKReferenceNode alloc] initWithFileNamed:OGInGameShopManagerShopScreenNodeName];
        _shopScreenNode.zPosition = OGZPositionCategoryTouchControl;
        
        OGButtonNode *resumeNode = (OGButtonNode *) [_shopScreenNode.children.firstObject childNodeWithName:OGInGameShopManagerResumeButtonName];
        resumeNode.target = self;
    }
    
    return self;
}


- (void)showWithShopItems:(NSArray<OGShopItemConfiguration *> *)shopItems
{
    __block NSInteger counter = 0;
    
    [self.shopScreenNode.children.firstObject enumerateChildNodesWithName:OGInGameShopManagerBuyItem usingBlock:^(SKNode *node, BOOL *stop)
    {
        if (shopItems.count > counter)
        {
            SKSpriteNode *textureNode = (SKSpriteNode *) [node childNodeWithName:OGInGameShopManagerTexture];
            textureNode.texture = shopItems[counter].texture;
            
            SKLabelNode *priceNode = (SKLabelNode *) [node childNodeWithName:OGInGameShopManagerPrice];
            priceNode.text = [shopItems[counter].price stringValue];
            
            ((OGButtonNode *) node).target = self;
            
            node.userData = [NSMutableDictionary dictionary];
            node.userData[OGInGameShopManagerBuyItemUserInfoUnitConfiguration] = shopItems[counter];
            
            counter++;
        }
    }];

    [self.delegate showInteractionWithNode:self.shopScreenNode];
}

- (void)onButtonClick:(OGButtonNode *)buttonNode
{
    if ([buttonNode.name isEqualToString:OGInGameShopManagerResumeButtonName])
    {
        [self.delegate closeCurrentInteraction];
    }
    else if ([buttonNode.name isEqualToString:OGInGameShopManagerBuyItem])
    {
        [self buyWithShopItemConfiguration:buttonNode.userData[OGInGameShopManagerBuyItemUserInfoUnitConfiguration]];
    }
}

- (void)buyWithShopItemConfiguration:(OGShopItemConfiguration *)shopItemConfiguration
{
    OGSceneItemEntity *buyItem = nil;
    
    if (shopItemConfiguration.unitClass == [OGShootingWeapon class])
    {
        SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:shopItemConfiguration.texture];
        
        CGFloat physicsBodyRadius = spriteNode.size.width / 2.0;
        spriteNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
        
        buyItem = [[shopItemConfiguration.unitClass alloc] initWithSpriteNode:spriteNode
                                                                configuration:(OGWeaponConfiguration *) shopItemConfiguration.unitConfiguration];
        
        buyItem.delegate = self.delegate;
    }
        
    [self.visitor itemWillBeTaken:buyItem];
}

@end
