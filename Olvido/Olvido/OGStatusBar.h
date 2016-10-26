//
//  OGStatusBar.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGStatusBar : NSObject

@property (nonatomic, assign) NSUInteger maxHealth;
@property (nonatomic, retain) SKSpriteNode *statusBarSprite;

- (void)createContents;

@end
