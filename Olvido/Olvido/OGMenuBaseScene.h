//
//  OGMenuBaseScene.h
//  Olvido
//
//  Created by Алексей Подолян on 11/11/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGBaseScene.h"

@class OGMenuManager;
@class OGButtonNode;

@interface OGMenuBaseScene : OGBaseScene

@property (nonatomic, strong, readonly) OGMenuManager *menuManager;

- (void)onButtonClick:(OGButtonNode *)button;

@end
