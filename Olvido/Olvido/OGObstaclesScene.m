//
//  OGObstaclesScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGObstaclesScene.h"

@implementation OGObstaclesScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blueColor];
}

- (void)addPortal:(OGPortal *)portal
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
