//
//  OGInputComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "OGControlInputSource.h"

@interface OGInputComponent : GKComponent <OGControlInputSourceDelegate>

@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

@end
