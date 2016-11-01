//
//  OGInventoryComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGSpriteNode;

@interface OGInventoryComponent : GKComponent

@property (nonatomic, assign) GKInspectable NSUInteger capacity;
@property (nonatomic, strong, readonly) NSArray<OGSpriteNode *> *inventory;

- (void)addItem:(OGSpriteNode *)item;
- (void)removeItem:(OGSpriteNode *)item;

@end
