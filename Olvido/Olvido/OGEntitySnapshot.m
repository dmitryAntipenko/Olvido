//
//  OGEntitySnapshot.m
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGEntitySnapshot.h"
#import "OGEntityDistance.h"
#import "OGPlayerEntity.h"

NSString *const kOGEntitySnapshotPlayerBotTargetTargetKey = @"target";
NSString *const kOGEntitySnapshotPlayerBotTargetDistanceKey = @"distance";

@interface OGEntitySnapshot ()

@property (nonatomic, strong) NSMutableArray<OGEntityDistance *> *mutableEntityDistances;
@property (nonatomic, strong) NSMutableDictionary *mutablePlayerTarget;

@end

@implementation OGEntitySnapshot

- (instancetype)init
{
    return [self initWithEntityDistances:[NSArray array] proximityFactor:0.0];
}

- (instancetype)initWithEntityDistances:(NSArray<OGEntityDistance *> *)entityDistances
                        proximityFactor:(CGFloat)proximityFactor
{
    self = [super init];
    
    if (self)
    {
        _proximityFactor = proximityFactor;
        _mutableEntityDistances = (NSMutableArray<OGEntityDistance *> *)entityDistances;
        _mutablePlayerTarget = [NSMutableDictionary dictionary];
        
        for (OGEntityDistance *entityDistance in _mutableEntityDistances)
        {
            if ([entityDistance.target isMemberOfClass:[OGPlayerEntity class]])
            {
                _mutablePlayerTarget[kOGEntitySnapshotPlayerBotTargetTargetKey] = entityDistance.target;
                _mutablePlayerTarget[kOGEntitySnapshotPlayerBotTargetDistanceKey] = @(entityDistance.distance);
                
                break;
            }
        }
    }
    
    return self;
}

- (NSArray<OGEntityDistance *> *)entityDistances
{
    return (NSArray<OGEntityDistance *> *) self.mutableEntityDistances;
}

- (NSDictionary *)playerTarget
{
    return (NSDictionary *) self.mutablePlayerTarget;
}

@end
