//
//  OGEnemyBehavior.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGGameScene;

@interface OGEnemyBehavior : GKBehavior

+ (NSDictionary *)behaviorAndPathPointsWithAgent:(GKAgent2D *)agent
                                    huntingAgent:(GKAgent2D *)huntingAgent
                                      pathRadius:(CGFloat)pathRadius
                                           scene:(OGGameScene *)scene;

@end
