//
//  OGTouchControlInputNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGControlInputSource.h"
#import "OGGUINode.h"

@interface OGTouchControlInputNode : OGGUINode

@property (nonatomic, weak) id<OGControlInputSourceDelegate> inputSourceDelegate;

- (instancetype)initWithFrame:(CGRect)frame thumbStickNodeSize:(CGSize)size;

@end
