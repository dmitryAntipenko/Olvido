//
//  OGZPositionEnum.m
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OGZPositionCategory)
{
    OGZPositionCategoryBackground = 0,
    OGZPositionCategoryUnderPhysicsWorld = 1000,
    OGZPositionCategoryPhysicsWorld = 2000,
    OGZPositionCategoryAbovePhysicsWorld = 3000,
    OGZPositionCategoryUnderForeground = 4000,
    OGZPositionCategoryForeground = 5000
};
