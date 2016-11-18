//
//  OGLoadResourcesOperation.h
//  Olvido
//
//  Created by Алексей Подолян on 11/10/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGResourceLoadable.h"
#import "OGLoadOperation.h"

@interface OGLoadResourcesOperation : OGLoadOperation

@property (nonatomic, strong, readonly) NSProgress *progress;

+ (instancetype)loadResourcesOperationWithLoadableClass:(Class<OGResourceLoadable>)loadableClass;

@end
