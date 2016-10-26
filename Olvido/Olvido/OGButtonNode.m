//
//  OGButtonNode.m
//  Olvido
//
//  Created by Алексей Подолян on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGButtonNode.h"

@interface OGButtonNode ()

@end

@implementation OGButtonNode

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"ended");
}

- (BOOL)isUserInteractionEnabled
{
    return YES;
}

@end
