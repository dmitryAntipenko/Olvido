//
//  OGLockComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGLockComponentDelegate.h"

@interface OGLockComponent : GKComponent

@property (nonatomic, weak) id<OGLockComponentDelegate> delegate;
@property (nonatomic, weak) SKNode *target;
@property (nonatomic, assign, getter=isLocked) BOOL locked;
@property (nonatomic, assign, getter=isClosed) BOOL closed;
@property (nonatomic, assign) CGFloat openDistance;

@end
