//
//  OGTouchControlInputNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGControlInputSource.h"

@interface OGTouchControlInputNode : SKSpriteNode

@property (nonatomic, weak) id<OGControlInputSourceDelegate> inputSourceDelegate;
@property (nonatomic, assign) BOOL shouldHideThumbStickNodes;

- (instancetype)initWithFrame:(CGRect)frame thumbStickNodeSize:(CGSize)size;

@end
