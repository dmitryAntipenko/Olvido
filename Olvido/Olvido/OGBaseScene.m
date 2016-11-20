//
//  OGBaseScene.m
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBaseScene.h"

@implementation OGBaseScene

- (void)createCamera
{
    self.scaleMode = SKSceneScaleModeAspectFit;
}

- (void)pause
{
    self.paused = YES;
}


- (void)resume
{
    self.paused = NO;
}

@end
