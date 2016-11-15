//
//  OGDeadBulletsManager.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGBullet;

@interface OGDeadBulletsManager : NSObject

+ (instancetype)sharedManager;

- (void)addItem:(OGBullet *)item;
- (void)removeItem:(OGBullet *)item;

@end
