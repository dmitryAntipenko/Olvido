//
//  OGDirection.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGDirection_h
#define OGDirection_h

typedef NS_ENUM(NSUInteger, OGDirection)
{
    kOGDirectionRight,
    kOGDirectionLeft
};

static NSString *const kOGDirectionDescription[] = {
    [kOGDirectionRight] = @"right",
    [kOGDirectionLeft] = @"left"
};

static NSInteger const kOGDirectionCount = 2;

#endif /* OGDirection_h */
