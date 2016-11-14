//
//  OGTransitionComponentDelegate.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@class OGTransitionComponent;

@protocol OGTransitionComponentDelegate <NSObject>

- (void)transitToDestinationWithTransitionComponent:(OGTransitionComponent *)component completion:(void (^)(void))completion;

@end
