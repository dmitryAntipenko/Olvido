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
#import "OGEntitySnapshot.h"

NSString *const kOGLevelStateSnapshotEntitiesKey = @"entities";
NSString *const kOGLevelStateSnapshotDistancesKey = @"distances";
NSString *const kOGLevelStateSnapshotSnapshotsKey = @"snapshots";
NSUInteger const OGLevelStateSnapshotProximityFactor = 900;

@interface OGLevelStateSnapshot ()

@property (nonatomic, strong) NSMutableDictionary *mutableSnapshot;
@property (nonatomic, strong) NSMutableArray<GKEntity *> *mutableEntities;
@property (nonatomic, strong) NSMutableArray<NSMutableArray<OGEntityDistance *> *> *mutableDistances;
@property (nonatomic, strong) NSMutableArray<OGEntitySnapshot *> *mutableSnapshots;
@end

@implementation OGLevelStateSnapshot

- (instancetype)initWithScene:(OGGameScene *)scene
{
    self = [super init];
    
    if (self)
    {
        _mutableDistances   = [NSMutableArray array];
        _mutableEntities    = [NSMutableArray array];
        _mutableSnapshots   = [NSMutableArray array];
        
        for (GKEntity *entity in scene.entities)
        {
            if ([entity componentForClass:[GKAgent2D class]])
            {
                [_mutableEntities addObject:entity];
                [_mutableDistances addObject:[NSMutableArray array]];
            }
        }
        
        for (GKEntity *entity in _mutableEntities)
        {
            NSUInteger index = [_mutableEntities indexOfObject:entity];
            GKAgent2D *sourceAgent = (GKAgent2D *) [entity componentForClass:[GKAgent2D class]];
            
            for (NSUInteger i = index + 1; i < _mutableEntities.count; i++)
            {
                GKEntity *targetEntity = _mutableEntities[i];
                GKAgent2D *targetAgent = (GKAgent2D *) [targetEntity componentForClass:[GKAgent2D class]];
               
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
        
        for (GKEntity *entity in _mutableEntities)
        {
            NSUInteger index = [_mutableEntities indexOfObject:entity];
            NSArray<OGEntityDistance *> *distances = _mutableDistances[index];
            OGEntitySnapshot *entitySnapshot = [[OGEntitySnapshot alloc] initWithEntityDistances:distances
                                                                                 proximityFactor:OGLevelStateSnapshotProximityFactor];
            
            [_mutableSnapshots addObject:entitySnapshot];
        }
        
        _mutableSnapshot = [NSMutableDictionary dictionary];
        _mutableSnapshot[kOGLevelStateSnapshotEntitiesKey] = _mutableEntities;
        _mutableSnapshot[kOGLevelStateSnapshotDistancesKey] = _mutableDistances;
        _mutableSnapshot[kOGLevelStateSnapshotSnapshotsKey] = _mutableSnapshots;
    }
    
    return self;
}

- (NSDictionary *)snapshot
{
    return (NSDictionary *) self.mutableSnapshot;
}

@end
