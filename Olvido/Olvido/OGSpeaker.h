//
//  OGSpeaker.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class OGSpeechCloud;

@interface OGSpeaker : SKSpriteNode

@property (nonatomic, retain) OGSpeechCloud *speechCloud;

- (instancetype)initWithSpeechCloud:(OGSpeechCloud *)speechCloud;

@end
