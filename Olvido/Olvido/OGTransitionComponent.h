//
//  OGTransitionComponent.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface OGTransitionComponent : GKComponent

@property (nonatomic, strong) SKNode *source;
@property (nonatomic, strong) SKNode *destination;

@end
