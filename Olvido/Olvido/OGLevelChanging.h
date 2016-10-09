//
//  OGLevelChanging.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol OGLevelChanging <NSObject>

- (void)changeBackgroundWithColor:(SKColor *)color;
- (void)changeAccentWithColor:(SKColor *)color;
- (void)changePlayerWithColor:(SKColor *)color;
- (void)changeEnemiesWithColor:(SKColor *)color enemyCount:(NSNumber *)count;
- (void)changeObstacles:(NSArray *)obstacles;
- (void)addRandomBonus;

@end
