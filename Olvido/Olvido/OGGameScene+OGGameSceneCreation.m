//
//  OGGameScene+OGGameSceneCreation.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 10/17/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGGameScene+OGGameSceneCreation.h"

CGFloat const kOGGameSceneBorderSize = 3.0;

@implementation OGGameScene (OGGameSceneCreation)

- (SKCropNode *)createBackgroundBorderWithColor:(SKColor *)color
{
    SKSpriteNode *border = [SKSpriteNode spriteNodeWithColor:color
                                                        size:self.frame.size];
    
    border.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    CGPathRef path = CGPathCreateWithRect(self.frame, nil);
    SKShapeNode *mask = [SKShapeNode shapeNodeWithPath:path];
    mask.lineWidth = pow(kOGGameSceneBorderSize, 2);
    
    SKCropNode *crop = [SKCropNode node];
    crop.maskNode = mask;
    [crop addChild:border];
    
    CGPathRelease(path);
    
    return crop;
}

@end
