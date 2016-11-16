//
//  OGTrailComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGTrailComponent : GKComponent

@property (nonatomic, strong) SKNode *targetNode;

- (instancetype)initWithTexture:(SKTexture *)trailTexture size:(CGSize)size;

+ (instancetype)trailComponentWithTexture:(SKTexture *)trailTexture  size:(CGSize)size;

@end
