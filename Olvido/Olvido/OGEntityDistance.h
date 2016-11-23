//
//  OGEntityDistance.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGEntityDistance : NSObject

@property (nonatomic, weak) GKEntity *source;
@property (nonatomic, weak) GKEntity *target;
@property (nonatomic, assign) CGFloat distance;

- (instancetype)initWithSource:(GKEntity *)source
                        target:(GKEntity *)target
                      distance:(CGFloat)distance NS_DESIGNATED_INITIALIZER;
@end
