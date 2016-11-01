//
//  OGStatusBar.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/26/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class OGHealthComponent;

@interface OGStatusBar : NSObject

@property (nonatomic, strong) SKSpriteNode *statusBarSprite;
@property (nonatomic, weak) OGHealthComponent *healthComponent;

- (void)createContents;
- (void)healthDidChange;

@end
