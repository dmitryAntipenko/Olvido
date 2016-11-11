//
//  OGTransitionComponentDelegate.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGTransitionComponentDelegate_h
#define OGTransitionComponentDelegate_h

@class OGTransitionComponent;

@protocol OGTransitionComponentDelegate <NSObject>

- (void)transitToDestinationWithTransitionComponent:(OGTransitionComponent *)component completion:(void (^)(void))completion;

@end

#endif /* OGTransitionComponentDelegate_h */
