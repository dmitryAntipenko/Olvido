//
//  OGBasicGameItem.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGBasicGameNode : SKNode

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGVector velocity;

- (void)changeNodeWithColor:(SKColor *)color;
- (void)moveToPoint:(CGPoint)point;

@end
