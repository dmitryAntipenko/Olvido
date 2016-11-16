//
//  OGLevelStateSnapshot.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGLevelStateSnapshot.h"
#import "OGGameScene.h"
#import "OGEntityDistance.h"

NSString *const kOGLevelStateSnapshotEntitiesKey = @"entities";
NSString *const kOGLevelStateSnapshotDistancesKey = @"distances";

@interface OGLevelStateSnapshot ()

@property (nonatomic, strong) NSMutableDictionary *mutableSnapshot;
@property (nonatomic, strong) NSMutableArray<GKEntity *> *mutableEntities;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<OGEntityDistance *> *> *mutableDistances;
@end

@implementation OGLevelStateSnapshot

- (instancetype)initWithScene:(OGGameScene *)scene
{
    self = [super init];
    
    if (self)
    {
        _mutableDistances = [NSMutableArray arrayWithCapacity:scene.entities.count];
        
        for (GKEntity *entity in scene.entities)
        {
            [_mutableEntities addObject:entity];
            
            [_mutableDistances addObject:[NSMutableArray array]];
        }
        
        for (GKEntity *entity in scene.entities)
        {
            NSUInteger index = [scene.entities indexOfObject:entity];
            GKAgent2D *sourceAgent = (GKAgent2D *) [entity componentForClass:GKAgent2D.self];
           
            for (NSUInteger i = index + 1; i < [scene.entities indexOfObject:scene.entities.lastObject]; i++)
            {
                GKEntity *targetEntity = scene.entities[i];
                GKAgent2D *targetAgent = (GKAgent2D *) [targetEntity componentForClass:GKAgent2D.self];
               
                CGFloat dx = targetAgent.position.x - sourceAgent.position.x;
                CGFloat dy = targetAgent.position.y - sourceAgent.position.y;
               
                CGFloat distance = hypotf(dx, dy);
               
                OGEntityDistance *sourceEntityDistance = [[OGEntityDistance alloc] initWithSource:entity
                                                                                           target:targetEntity
                                                                                         distance:distance];
                OGEntityDistance *targetEntityDistance = [[OGEntityDistance alloc] initWithSource:targetEntity
                                                                                           target:entity
                                                                                         distance:distance];
                [_mutableDistances[index] addObject:sourceEntityDistance];
                [_mutableDistances[i] addObject:targetEntityDistance];
            }
        }
        
        _mutableSnapshot[kOGLevelStateSnapshotEntitiesKey] = _mutableEntities;
        _mutableSnapshot[kOGLevelStateSnapshotDistancesKey] = _mutableDistances;
    }
    
    return self;
}

- (NSMutableArray<GKEntity *> *)mutableEntities
{
    if (!_mutableEntities)
    {
        _mutableEntities = [[NSMutableArray alloc] init];
    }
    
    return _mutableEntities;
}

- (NSMutableDictionary *)mutableSnapshot
{
    if (!_mutableSnapshot)
    {
        _mutableSnapshot = [[NSMutableDictionary alloc] init];
    }
    
    return _mutableSnapshot;
}

- (NSDictionary *)snapshot
{
    return (NSDictionary *) self.mutableSnapshot;
}

@end
