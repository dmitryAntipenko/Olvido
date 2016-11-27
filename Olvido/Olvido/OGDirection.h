//
//  OGDirection.h
//  Olvido
//
//  Created by Александр Песоцкий on 11/7/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

typedef NS_ENUM(NSUInteger, OGDirection)
{
    OGDirectionRight,
    OGDirectionLeft
};

static NSString *const OGDirectionDescription[] = {
    [OGDirectionRight] = @"right",
    [OGDirectionLeft] = @"left"
};

static NSInteger const OGDirectionCount = 2;
