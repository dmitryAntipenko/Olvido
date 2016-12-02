//
//  OGHealthComponentDelegate.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/20/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@class OGHealthComponent;

@protocol OGHealthComponentDelegate <NSObject>

@optional
- (void)healthDidChange;
- (void)entityWillDie;

- (void)restoreEntityHealth:(NSInteger)health;
- (void)dealDamageToEntity:(NSInteger)damage;

@end
