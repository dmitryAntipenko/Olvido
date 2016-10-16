//
//  OGPortal.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/16/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@import GameplayKit;

#import "OGPortalLocation.h"

@interface OGPortal : GKEntity

@property (nonatomic, assign) OGPortalLocation location;
@property (nonatomic, getter=isClosed) BOOL closed;
@property (nonatomic, retain) SKColor *color;

+ (instancetype)portalWithLocation:(OGPortalLocation)location;

@end
