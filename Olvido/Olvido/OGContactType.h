//
//  OGContactType.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGContactType_h
#define OGContactType_h

typedef NS_ENUM(NSUInteger, OGContactType)
{
    kOGContactTypeNone = -1,
    kOGContactTypeGameOver = 0,
    kOGContactTypePlayerDidGetCoin = 1,
    kOGContactTypePlayerDidTouchPortal = 2
};

#endif /* OGContactType_h */
