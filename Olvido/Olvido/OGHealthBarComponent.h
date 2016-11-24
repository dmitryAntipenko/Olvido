//
//  OGHealthBarComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/24/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGHealthBarComponent : GKComponent

+ (instancetype)healthBarComponent;

- (void)redrawBarNode;

@end
