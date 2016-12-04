//
//  OGEnemyConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGEntityConfiguration.h"

@interface OGEnemyConfiguration : OGEntityConfiguration

@property (nonatomic, assign) Class enemyClass;

@property (nonatomic, assign, readonly) CGFloat physicsBodyRadius;
@property (nonatomic, assign, readonly) CGFloat maxHealth;
@property (nonatomic, assign, readonly) CGFloat currentHealth;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
