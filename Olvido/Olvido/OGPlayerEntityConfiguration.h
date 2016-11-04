//
//  OGPlayerEntityConfiguration.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/4/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

struct OGPlayerEntityConfiguration
{
    NSUInteger const maxHealth;
    NSUInteger const currentHealth;
};

extern const struct OGPlayerEntityConfiguration playerConfiguration;
