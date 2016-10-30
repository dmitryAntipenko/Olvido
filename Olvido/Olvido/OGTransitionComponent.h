//
//  OGTransitionComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGTransitionComponent : GKComponent

@property (nonatomic, assign) GKInspectable NSUInteger identifier;
@property (nonatomic, getter=isClosed) GKInspectable BOOL closed;

@end
