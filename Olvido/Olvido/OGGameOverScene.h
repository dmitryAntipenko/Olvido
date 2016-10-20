//
//  OGGameOverScene.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/19/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene.h"

@interface OGGameOverScene : SKScene

@property (nonatomic, retain) NSNumber *score;

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

@property (nonatomic, retain) GKStateMachine *uiStateMachine;

@end
