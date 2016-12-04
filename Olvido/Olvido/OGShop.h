//
//  OGShop.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInteractionsManaging.h"

@interface OGShop : GKEntity

@property (nonatomic, weak) id<OGInteractionsManaging> delegate;

- (instancetype)initWithSpriteNode:(SKSpriteNode *)sprite;

@end
