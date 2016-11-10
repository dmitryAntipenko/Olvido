//
//  OGLockComponentDelegate.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#ifndef OGLockComponentDelegate_h
#define OGLockComponentDelegate_h

@protocol OGLockComponentDelegate <NSObject>

- (void)shouldClose;
- (void)shouldOpen;

@end

#endif /* OGLockComponentDelegate_h */
