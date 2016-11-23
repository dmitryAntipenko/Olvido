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
    kOGCollisionBitMaskDefault      = 0x0,
    kOGCollisionBitMaskPlayer       = 0x01 << 1,    //2
    kOGCollisionBitMaskEnemy        = 0x01 << 2,    //4
    kOGCollisionBitMaskObstacle     = 0x01 << 3,    //8
    kOGCollisionBitMaskWeapon       = 0x01 << 4,    //16
    kOGCollisionBitMaskDoor         = 0x01 << 5,    //32
    kOGCollisionBitMaskDoorTrigger  = 0x01 << 6,    //64
    kOGCollisionBitMaskBullet       = 0x01 << 7,    //128
    kOGCollisionBitMaskKey          = 0x01 << 8     //256
};

#endif /* Header_h */
