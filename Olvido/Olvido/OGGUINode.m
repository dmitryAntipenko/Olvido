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

- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size
{
    self = [super initWithTexture:texture color:color size:size];
    
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
