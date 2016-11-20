//
//  OGMenuManager.h
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OGAudioManager.h"

@class OGSceneManager;

@interface OGMenuManager : NSObject

@property (nonatomic, strong) OGSceneManager *sceneManager;
@property (nonatomic, strong, readonly) OGAudioManager *audioManager;

+ (instancetype)sharedInstance;

- (void)loadMainMenu;

- (void)loadMenuWithIdentifier:(NSUInteger)menuIdentifier;

- (void)loadMenuWithName:(NSString *)menuName;

@end
