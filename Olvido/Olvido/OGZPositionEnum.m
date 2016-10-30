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
    OGZPositionCategoryBackground = -200,
    OGZPositionCategoryPhysicsWorld = -100,
    OGZPositionCategoryAbovePhysicsWorld = 0,
    OGZPositionCategoryUnderForeground = 100,
    OGZPositionCategoryForeground = 200
};
