//
//  OGColliderType.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGColliderType_h
#define OGColliderType_h

struct OGColliderType
{
    uint32_t categoryBitMask;
    uint32_t collisionBitMask;
    uint32_t contactTestBitMask;
};

//extern const struct OGColliderType colliderType;

#endif /* OGColliderType_h */
