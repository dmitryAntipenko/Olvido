//
//  OGLevel1.m
//  Olvido
//
//  Created by Алексей Подолян on 12/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevel1.h"
#import "OGEnemyEntity.h"

NSUInteger const OGLevel1CompletionEnemiesCount = 0;

@interface OGLevel1 ()

@property (nonatomic, strong) NSMutableArray<OGEnemyEntity *> *enemies;

@end

@implementation OGLevel1

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    
    self.enemies = [[NSMutableArray alloc] init];
    
    for (GKEntity *entity in self.entities)
    {
        if ([entity isKindOfClass:[OGEnemyEntity class]])
        {
            [self.enemies addObject:(OGEnemyEntity *)entity];
        }
    }
    
}

- (void)removeEntity:(GKEntity *)entity
{   
    if ([entity isKindOfClass:[OGEnemyEntity class]])
    {
        [self.enemies removeObject:(OGEnemyEntity *)entity];
        
        if (self.enemies.count == OGLevel1CompletionEnemiesCount)
        {
            [self.sceneDelegate didCallComplete];
        }
    }
    
    [super removeEntity:entity];
}

@end
