//
//  OGPlayerConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGEntityConfiguration.h"

@interface OGPlayerConfiguration : OGEntityConfiguration

@property (nonatomic, assign, readonly) CGFloat physicsBodyRadius;
@property (nonatomic, assign, readonly) CGFloat messageShowDistance;
@property (nonatomic, assign, readonly) CGFloat maxHealth;
@property (nonatomic, assign, readonly) CGFloat currentHealth;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
