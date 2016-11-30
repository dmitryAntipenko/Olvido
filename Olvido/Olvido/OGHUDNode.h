//
//  OGHUDNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGHUDElement.h"

@class OGPlayerEntity;

@interface OGHUDNode : SKSpriteNode

@property (nonatomic, weak) OGPlayerEntity *playerEntity;
@property (nonatomic, strong, readonly) NSArray<id<OGHUDElement>> *hudElements;

- (void)addHUDElement:(id<OGHUDElement>)element;
- (void)removeHUDElement:(id<OGHUDElement>)element;

- (void)updateHUD;

@end
