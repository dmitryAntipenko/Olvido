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

/* temporary code */
@property (nonatomic, copy) NSString *controlType;
@property (nonatomic, assign) BOOL godMode;
/* temporary code */

- (void)loadLevelMap;
- (void)loadInitialLevel;

@end
