//
//  OGWeaponComponentObserving.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@protocol OGWeaponComponentObserving <NSObject>

- (void)weaponWasTakenWithProperties:(NSDictionary *)properties;
- (void)weaponWasRemoved;
- (void)weaponDidUpdateKey:(NSString *)key withValue:(NSValue *)value;

@end
