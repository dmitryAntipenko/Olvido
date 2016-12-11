//
//  OGInteractionsManaging.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@class OGScreenNode;

@protocol OGInteractionsManaging <NSObject>

- (void)showInteractionButtonWithNode:(SKNode *)node;
- (void)showInteractionWithNode:(OGScreenNode *)node;
- (void)closeCurrentInteraction;

@end
