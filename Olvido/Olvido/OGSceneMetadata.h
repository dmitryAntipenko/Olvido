//
//  OGSceneMetadata.h
//  Olvido
//
//  Created by Алексей Подолян on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, OGSceneType)
{
    OGSceneTypeLevel = 0,
    OGSceneTypeMenu = 1
};

@interface OGSceneMetadata : NSObject

@property (nonatomic, unsafe_unretained) NSUInteger identifier;
@property (nonatomic, unsafe_unretained) OGSceneType sceneType;

@end
