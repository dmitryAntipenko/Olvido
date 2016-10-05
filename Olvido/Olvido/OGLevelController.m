//
//  OGLevelController.m
//  Olvido
//
//  Created by Алексей Подолян on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelController.h"
#import "OGGameScene.h"
#import "OGLevel.h"

@interface OGLevelController ()

@property (nonatomic, retain) OGGameScene *gameScene;
@property (nonatomic, assign) OGLevel *currentLevel;
@property (nonatomic, retain) NSMutableArray<OGLevel *> *levels;

@end

@implementation OGLevelController

- (void)updateGameScene
{
    //...
}

@end
