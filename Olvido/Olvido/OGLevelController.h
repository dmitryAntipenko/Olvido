//
//  OGLevelController.h
//  Olvido
//
//  Created by Алексей Подолян on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGLevelChanging.h"

extern NSUInteger const kOGLevelControllerLevelChangeInterval;

@interface OGLevelController : NSObject

@property (nonatomic, assign) id <OGLevelChanging> gameScene;

- (void)loadLevelWithNumber:(NSNumber *)number;

@end
