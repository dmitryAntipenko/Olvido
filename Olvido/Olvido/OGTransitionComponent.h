//
//  OGTransitionComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
@class OGRoom;

@interface OGTransitionComponent : GKComponent

@property (nonatomic, weak) OGRoom *source;
@property (nonatomic, weak) OGRoom *destination;

@end
