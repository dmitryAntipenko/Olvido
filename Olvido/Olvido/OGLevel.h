//
//  OGLevel.h
//  Olvido
//
//  Created by Алексей Подолян on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGObstacleNode;

@interface OGLevel : NSObject

@property (nonatomic, retain) NSNumber *identifier;

@property (nonatomic, copy) SKColor *backgroundColor;
@property (nonatomic, copy) SKColor *accentColor;
@property (nonatomic, copy) SKColor *playerColor;
@property (nonatomic, copy) SKColor *enemyColor;

@property (nonatomic, copy, readonly) NSArray<OGObstacleNode *> *obstacles;

@property (nonatomic, retain) NSNumber *enemyCount;

- (BOOL)addObstacle:(OGObstacleNode *)obstacle;

@end
