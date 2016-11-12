//
//  OGThumbStickNodeDelegate.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGThumbStickNodeDelegate_h
#define OGThumbStickNodeDelegate_h

@protocol OGThumbStickNodeDelegate

- (void)thumbStickNode:(SKSpriteNode *)node didUpdateXValue:(CGFloat)xValue yValue:(CGFloat)yValue;

@end

#endif /* OGThumbStickNodeDelegate_h */
