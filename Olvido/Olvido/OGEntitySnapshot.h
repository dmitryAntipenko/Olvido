//
//  OGEntitySnapshot.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGEntityDistance;

extern NSString *const OGEntitySnapshotPlayerBotTargetTargetKey;
extern NSString *const OGEntitySnapshotPlayerBotTargetDistanceKey;

@interface OGEntitySnapshot : NSObject

- (instancetype)initWithEntityDistances:(NSArray<OGEntityDistance *> *)entityDistances
                        proximityFactor:(CGFloat)proximityFactor NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) NSArray<OGEntityDistance *> *entityDistances;
@property (nonatomic, strong, readonly) NSDictionary *playerTarget;
@property (nonatomic, assign) CGFloat proximityFactor;

@end
