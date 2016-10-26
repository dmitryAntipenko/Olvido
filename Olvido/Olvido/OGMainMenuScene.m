//
//  OGMainMenuScene.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGMainMenuScene.h"
#import "OGButtonNode.h"

@interface OGMainMenuScene ()


@end

@implementation OGMainMenuScene

- (void)didMoveToView:(SKView *)view
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [touches.anyObject locationInNode:self];
    [[self nodeAtPoint:touchLocation] touchesBegan:touches withEvent:event];
}

@end
