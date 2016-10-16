//
//  OGMovingObstaclesScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMovingObstaclesScene.h"

@implementation OGMovingObstaclesScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor yellowColor];
}

- (void)addPortalWithPosition:(OGPortalPosition)position nextLevelIdentifier:(NSNumber *)identifier
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sceneDelegate gameSceneDidCallFinish];
}

- (void)dealloc
{    
    [super dealloc];
}

@end
