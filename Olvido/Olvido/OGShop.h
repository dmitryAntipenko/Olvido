//
//  OGShop.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGInteractionsManaging.h"
#import "OGSceneItemEntity.h"

@interface OGShop : OGSceneItemEntity

@property (nonatomic, weak) id<OGInteractionsManaging> interactionDelegate;

@end
