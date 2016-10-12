//
//  OGScoreController.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/5/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OGLevelController;

@interface OGScoreController : NSObject

@property (nonatomic, retain, readonly) NSNumber *score;

- (void)incrementScore;

@end
