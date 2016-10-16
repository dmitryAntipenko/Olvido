//
//  OGInitialScene.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGInitialScene.h"
#import "OGEnemyEntity.h"

NSUInteger const kOGInitialSceneEnemiesCount = 4;

@interface OGInitialScene ()


@end

@implementation OGInitialScene

- (void)createSceneContents
{
    self.backgroundColor = [SKColor redColor];
    
    NSMutableArray<OGEnemyEntity *> *enemies = [NSMutableArray arrayWithCapacity:kOGInitialSceneEnemiesCount];
    
    for (NSUInteger i = 0; i < kOGInitialSceneEnemiesCount; i++)
    {
        OGEnemyEntity *enemy = [[OGEnemyEntity alloc] init];
    }

}

- (void)addPortalWithPosition:(OGPortalPosition)position nextLevelIdentifier:(NSNumber *)identifier
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[self.sceneDelegate gameSceneDidCallFinish];
}

- (void)dealloc
{

    
    [super dealloc];
}

@end
