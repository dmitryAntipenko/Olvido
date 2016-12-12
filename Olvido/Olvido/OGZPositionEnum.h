//
//  OGZPositionEnum.h
//  Olvido
//
//  Created by Алексей Подолян on 10/30/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OGZPositionCategory)
{
    OGZPositionCategoryBackground = -200,
    OGZPositionCategoryShadows = -150,
    OGZPositionCategoryEntities = 0,
    OGZPositionCategoryForeground = 3000,
    OGZPositionCategoryTouchControl = 3600,
    OGZPositionCategoryInteractions = 3700,
    OGZPositionCategoryHUD = 3800,
    OGZPositionCategoryScreens = 4000,
//    OGZPositionCategoryBackground = -2000,
//    OGZPositionCategoryUnderPhysicsWorld = -1000,
//    OGZPositionCategoryShadows = -100,
//    OGZPositionCategoryPhysicsWorld = 0,
//    OGZPositionCategoryAbovePhysicsWorld = 2000,
//    OGZPositionCategoryUnderForeground = 2500,
//    OGZPositionCategoryForeground = 3000,
//    OGZPositionCategoryTouchControl = 3500,
};
