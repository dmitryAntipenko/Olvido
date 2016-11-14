//
//  OGGameSceneConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGEnemyConfiguration;

@interface OGGameSceneConfiguration : NSObject

@property (nonatomic, strong, readonly) NSArray<OGEnemyConfiguration *> *enemiesConfiguration;

+ (instancetype)gameSceneConfigurationWithFileName:(NSString *)fileName;

@end
