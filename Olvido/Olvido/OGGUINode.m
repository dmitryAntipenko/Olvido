//
//  OGGUINode.m
//  Olvido
//
//  Created by Алексей Подолян on 11/18/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGUINode.h"
#import "OGZPositionEnum.m"

@implementation OGGUINode

@synthesize zPosition = _zPosition;

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _zPosition = OGZPositionCategoryForeground;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        _zPosition = OGZPositionCategoryForeground;
    }
    
    return self;

}

@end
