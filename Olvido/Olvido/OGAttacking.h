//
//  OGAttacking.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/12/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@protocol OGAttacking <NSObject>

@optional
- (void)attack;
- (void)attackWithVector:(CGVector)vector speed:(CGFloat)speed;
- (void)attackDidEnd;

- (void)reload;

@end
