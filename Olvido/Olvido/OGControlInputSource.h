//
//  OGControlInputSource.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@protocol OGControlInputSourceDelegate <NSObject>

- (void)didUpdateDisplacement:(CGVector)displacement;
- (void)didUpdateAttackDisplacement:(CGVector)displacement;
- (void)didPressed:(BOOL)pressed;

@end
