//
//  OGBaseScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBaseScene.h"

@implementation OGBaseScene

- (void)configureScene
{
    self.scaleMode = SKSceneScaleModeFill;
}

- (void)pause
{
    self.customPaused = YES;
}

- (void)resume
{
    self.customPaused = NO;
}

@end
