//
//  OGResourceLoadableType.h
//  Olvido
//
//  Created by Алексей Подолян on 11/9/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OGResourceLoadable <NSObject>

+ (BOOL)resourcesNeedLoading;

+ (void)loadResourcesWithCompletionHandler:(void (^)())completionHandler;

+ (void)purgeResources;

@end
