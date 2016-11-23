//
//  OGHealthComponentDelegate.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@class OGHealthComponent;

@protocol OGHealthComponentDelegate <NSObject>

- (void)entityWillDie;
- (void)dealDamage:(NSInteger)damage;

@end
