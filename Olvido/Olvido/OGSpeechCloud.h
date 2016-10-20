//
//  OGSpeechCloud.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGAnimationAction.h"

@interface OGSpeechCloud : SKSpriteNode

@property (nonatomic, copy) NSString *speechText;
@property (nonatomic, assign) OGAnimationActionType animationAction;

@end
