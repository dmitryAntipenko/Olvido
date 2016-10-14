//
//  OGScenesController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/14/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGScenesController : NSObject

@property (nonatomic, assign) SKView *view;

- (void)loadLevelMap;
- (void)loadInitialLevel;

@end
