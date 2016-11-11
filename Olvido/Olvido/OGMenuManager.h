//
//  OGMenuManager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGSceneManager;

@interface OGMenuManager : NSObject

@property (nonatomic, strong) OGSceneManager *sceneManager;

+ (instancetype)menuManager;

@end
