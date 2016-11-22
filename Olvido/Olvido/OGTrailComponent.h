//
//  OGTrailComponent.h
//  Olvido
//
//  Created by Алексей Подолян on 11/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGTrailComponent : GKComponent

@property (nonatomic, weak) SKNode *targetNode;
@property (nonatomic, strong) SKTexture *texture;
@property (nonatomic, assign) CGSize textureSize;

+ (instancetype)trailComponent;

- (void)pause;
- (void)play;

@end
