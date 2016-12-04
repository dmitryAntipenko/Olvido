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
    OGCollisionBitMaskDefault      = 0x0,
    OGCollisionBitMaskPlayer       = 0x01 << 1,    //2
    OGCollisionBitMaskEnemy        = 0x01 << 2,    //4
    OGCollisionBitMaskObstacle     = 0x01 << 3,    //8
    OGCollisionBitMaskWeapon       = 0x01 << 4,    //16
    OGCollisionBitMaskDoor         = 0x01 << 5,    //32
    OGCollisionBitMaskDoorTrigger  = 0x01 << 6,    //64
    OGCollisionBitMaskBullet       = 0x01 << 7,    //128
    OGCollisionBitMaskSceneItem    = 0x01 << 8,    //256
    OGCollisionBitMaskZone         = 0x01 << 9,    //512
    OGCollisionBitMaskShop         = 0x01 << 10    //1024
};

#endif /* Header_h */
