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
    OGDirectionLeft,
    OGDirectionRight
};

static NSString *const kOGDirectionDescription[] = {
    [OGDirectionLeft] = @"left",
    [OGDirectionRight] = @"right"
};

#endif /* OGDirection_h */
