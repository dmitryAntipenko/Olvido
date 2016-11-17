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
    kOGZPositionCategoryBackground = -200,
    kOGZPositionCategoryPhysicsWorld = -100,
    kOGZPositionCategoryAbovePhysicsWorld = 0,
    kOGZPositionCategoryUnderForeground = 100,
    kOGZPositionCategoryForeground = 200,
    kOGZPositionHUD = 3000
};
