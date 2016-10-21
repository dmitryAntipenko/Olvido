//
//  OGAccessComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGAccessComponentDelegate.h"

@interface OGAccessComponent : GKComponent

@property (nonatomic, assign) id<OGAccessComponentDelegate> componentDelegate;

- (void)grantAccessWithCompletionBlock:(void (^)())completion;

@end
