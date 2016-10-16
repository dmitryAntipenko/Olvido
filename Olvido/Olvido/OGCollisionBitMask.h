//
//  Header.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef Header_h
#define Header_h

typedef NS_ENUM(NSUInteger, OGCollisionBitMask)
{
    kOGCollisionBitMaskDefault = 0x0,
    kOGCollisionBitMaskPlayer = 0x01 << 1,
    kOGCollisionBitMaskEnemy = 0x01 << 2,
    kOGCollisionBitMaskObstacle = 0x01 << 3,
    kOGCollisionBitMaskBonus = 0x01 << 4,
    kOGCollisionBitMaskPortal = 0x01 << 5
};

#endif /* Header_h */
