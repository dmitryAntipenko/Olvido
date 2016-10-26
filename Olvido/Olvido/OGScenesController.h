//
//  OGScenesController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGGameScene;

@interface OGScenesController : NSObject

@property (nonatomic, assign) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, retain, readonly) OGGameScene *currentScene;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;
- (void)runScene;

@end
