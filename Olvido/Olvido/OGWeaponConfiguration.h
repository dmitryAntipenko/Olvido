//
//  OGWeaponConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 12/1/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "OGEntityConfiguration.h"

@class OGShellConfiguration;

@interface OGWeaponConfiguration : OGEntityConfiguration

@property (nonatomic, assign, readonly) CGFloat attackSpeed;
@property (nonatomic, assign, readonly) CGFloat reloadSpeed;
@property (nonatomic, assign, readonly) NSUInteger charge;
@property (nonatomic, assign, readonly) NSUInteger maxCharge;
@property (nonatomic, assign, readonly) CGFloat spread;
@property (nonatomic, strong, readonly) OGShellConfiguration *shellConfiguration;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
