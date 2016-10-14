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

- (void)addPortalWithPosition:(OGPortalPosition)position nextLevelIdentifier:(NSNumber *)identifier
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sceneDelegate gameSceneDidCallFinish];
}

- (void)dealloc
{
    [_enemies release];
    [_player release];
    [_identifier release];
    [_portals release];
    [_sceneDelegate release];
    
    [super dealloc];
}

@end
