//
//  OGBasicGameItem.h
//  Olvido
//
//  Created by Александр Песоцкий on 10/6/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

extern CGFloat const kOGBasicGameNodeRadius;

@interface OGBasicGameNode : SKNode

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGVector velocity;
@property (nonatomic, retain) SKColor *color;
@property (nonatomic, retain) SKCropNode *appearance;

- (instancetype)initWithColor:(SKColor *)color
                       radius:(CGFloat)radius
                     velocity:(CGVector)velocity
                   appearance:(SKCropNode *)appearence
                         skin:(SKCropNode *)skin;
- (instancetype)initWithColor:(SKColor *)color;

- (void)moveToPoint:(CGPoint)point;

@end
