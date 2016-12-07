//
//  OGInteractionsManaging.h
//  Olvido
//
//  Created by Александр Песоцкий on 12/2/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@protocol OGInteractionsManaging <NSObject>

- (void)showInteractionWithNode:(SKNode *)node;
- (void)closeCurrentInteraction;

@end
