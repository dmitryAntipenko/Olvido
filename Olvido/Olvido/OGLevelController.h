//
//  OGLevelController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class OGGameScene;

@interface OGLevelController : NSObject

@property (nonatomic, assign) SKView *view;

@property (nonatomic, copy, readonly) NSArray *levelMap;
@property (nonatomic, retain, readonly) OGGameScene *currentScene;

+ (OGLevelController *)sharedInstance;

- (void)loadLevelMap;
- (void)loadLevelWithIdentifier:(NSNumber *)identifier;
- (void)runScene;

@end
