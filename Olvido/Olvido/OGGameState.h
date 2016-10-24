//
//  OGGameState.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGUIState.h"
@class OGScenesController;

@interface OGGameState : OGUIState

@property (nonatomic, retain) OGScenesController *scenesController;

@end
