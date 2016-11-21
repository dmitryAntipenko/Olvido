//
//  OGEnemyConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGEnemyConfiguration : NSObject

@property (nonatomic, assign, readonly) CGFloat physicsBodyRadius;
@property (nonatomic, copy, readonly) NSString *initialPointName;
@property (nonatomic, assign, readonly) CGVector initialVector;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
