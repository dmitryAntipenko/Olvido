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
#import "OGZPositionEnum.h"

NSString *const OGInGameShopManagerShopScreenNodeName = @"OGShopScreen.sks";
NSString *const OGInGameShopManagerBuyItem = @"BuyItem";
NSString *const OGInGameShopManagerTexture = @"Texture";
NSString *const OGInGameShopManagerPrice = @"Price";

NSString *const OGInGameShopManagerMoneyLabel = @"MoneyLabel";

NSString *const OGInGameShopManagerOpenShopButtonName = @"OpenShop";
NSString *const OGInGameShopManagerOpenShopButtonUserData = @"OpenShopButtonUserData";
NSString *const OGInGameShopManagerResumeButtonName = @"ResumeFromShopButton";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitConfiguration = @"UnitConfiguration";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitClass = @"UnitClass";
NSString *const OGInGameShopManagerBuyItemUserInfoUnitConfigurationClass = @"UnitConfigurationClass";

NSString *const OGInGameShopManagerShopButtonName = @"shop_button";

CGFloat const OGInGameShopManagerStratMoney = 1000.0;

@interface OGInGameShopManager ()

@property (nonatomic, strong) SKReferenceNode *shopScreenNode;

@property (nonatomic, strong) NSMutableDictionary<NSString *, OGButtonNode *> *buttonNodes;
@property (nonatomic, strong) NSMutableArray<OGShopItemConfiguration *> *shopItemConfigurations;

@property (nonatomic, assign) CGFloat money;

@end

@implementation OGInGameShopManager

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _shopScreenNode = [[SKReferenceNode alloc] initWithFileNamed:OGInGameShopManagerShopScreenNodeName];
        _shopScreenNode.zPosition = OGZPositionCategoryScreens;
        
        OGButtonNode *resumeNode = (OGButtonNode *) [_shopScreenNode.children.firstObject childNodeWithName:OGInGameShopManagerResumeButtonName];
        resumeNode.target = self;
        
        _buttonNodes = [[NSMutableDictionary alloc] init];
        
        _money = OGInGameShopManagerStratMoney;
    }
    
    return self;
}

- (void)showShopButtonWithIdentifier:(NSString *)identifier
                         shopItems:(NSArray<OGShopItemConfiguration *> *)shopItems
{
    OGButtonNode *shopButton = [[OGButtonNode alloc] initWithImageNamed:OGInGameShopManagerShopButtonName];
    shopButton.target = self;
    shopButton.name = OGInGameShopManagerOpenShopButtonName;
    shopButton.size = CGSizeMake(75, 75);
    
    shopButton.zPosition = OGZPositionCategoryInteractions;
    
    shopButton.userData = [NSMutableDictionary dictionary];
    shopButton.userData[OGInGameShopManagerOpenShopButtonUserData] = shopItems;
    
    self.buttonNodes[identifier] = shopButton;
    
    [self.delegate showInteractionButtonWithNode:shopButton];
}

- (void)hideShopButtonWithIdentifier:(NSString *)identifier
{
    if (self.buttonNodes[identifier].parent)
    {
        [self.buttonNodes[identifier] removeFromParent];
    }
    
    [self.buttonNodes removeObjectForKey:identifier];
}

- (void)showShopScreenWithItems:(NSArray<OGShopItemConfiguration *> *)shopItems
{
    self.shopItemConfigurations = (NSMutableArray *)shopItems;
    
    [self updateMoneyLabelWithValue:self.money];
    [self updateItemsWithItems:self.shopItemConfigurations];

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
    else if ([buttonNode.name isEqualToString:OGInGameShopManagerOpenShopButtonName])
    {
        [self showShopScreenWithItems:buttonNode.userData[OGInGameShopManagerOpenShopButtonUserData]];
    }
}

- (void)buyWithShopItemConfiguration:(OGShopItemConfiguration *)shopItemConfiguration
{
    OGSceneItemEntity *buyItem = nil;
    
    SKSpriteNode *spriteNode = [SKSpriteNode spriteNodeWithTexture:shopItemConfiguration.texture];
    
    CGFloat physicsBodyRadius = spriteNode.size.width / 2.0;
    spriteNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
    
    buyItem = [[shopItemConfiguration.unitClass alloc] initWithSpriteNode:spriteNode
                                                            configuration:(id)shopItemConfiguration.unitConfiguration];
    
    buyItem.delegate = self.delegate;
    
    if (buyItem && self.money >= shopItemConfiguration.price.floatValue)
    {
        [self.visitor itemWillBeTaken:buyItem];
        self.money -= shopItemConfiguration.price.floatValue;
        
        [self updateMoneyLabelWithValue:self.money];
        [self.shopItemConfigurations removeObject:shopItemConfiguration];
        [self updateItemsWithItems:self.shopItemConfigurations];
    }
}

- (void)updateMoneyLabelWithValue:(CGFloat)value
{
    SKNode *shopNode = self.shopScreenNode.children.firstObject;
    
    SKLabelNode *moneyLabel = (SKLabelNode *) [shopNode childNodeWithName:OGInGameShopManagerMoneyLabel];
    moneyLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)updateItemsWithItems:(NSArray<OGShopItemConfiguration *> *)shopItems
{
    SKNode *shopNode = self.shopScreenNode.children.firstObject;
    
    __block NSInteger counter = 0;
    
    [shopNode enumerateChildNodesWithName:OGInGameShopManagerBuyItem usingBlock:^(SKNode *node, BOOL *stop)
     {
         if (shopItems.count > counter)
         {
             SKSpriteNode *textureNode = (SKSpriteNode *) [node childNodeWithName:OGInGameShopManagerTexture];
             textureNode.texture = shopItems[counter].texture;
             
             SKLabelNode *priceNode = (SKLabelNode *) [node childNodeWithName:OGInGameShopManagerPrice];
             priceNode.text = [NSString stringWithFormat:@"%.2f", [shopItems[counter].price floatValue]];
             
             ((OGButtonNode *) node).target = self;
             
             node.userData = [NSMutableDictionary dictionary];
             node.userData[OGInGameShopManagerBuyItemUserInfoUnitConfiguration] = self.shopItemConfigurations[counter];
             
             counter++;
         }
         else
         {
             SKSpriteNode *textureNode = (SKSpriteNode *) [node childNodeWithName:OGInGameShopManagerTexture];
             textureNode.texture = nil;
             
             SKLabelNode *priceNode = (SKLabelNode *) [node childNodeWithName:OGInGameShopManagerPrice];
             priceNode.text = @"";
             
             ((OGButtonNode *) node).target = nil;
             node.userData = nil;
             
             counter++;
         }
     }];
}

@end
