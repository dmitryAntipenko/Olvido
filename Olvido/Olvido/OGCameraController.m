    //
//  OGCameraNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGCameraController.h"
#import "OGCollisionBitMask.h"

@interface OGCameraController ()

@property (nonatomic, weak) SKSpriteNode *rails;

@end

@implementation OGCameraController

- (void)moveCameraToNode:(SKNode *)node
{
    [self setCameraConstraintsWithNode:node];
}

- (void)setCameraConstraintsWithNode:(SKNode *)node
{
    if (self.camera)
    {
        SKRange *zeroRange = [SKRange rangeWithConstantValue:0.0];
        SKConstraint *targetConstraint = [SKConstraint distance:zeroRange toNode:self.target];
        
        CGRect nodeRect = node.calculateAccumulatedFrame;
        
        CGFloat xInset = self.camera.scene.size.width / 2;
        CGFloat yInset = self.camera.scene.size.height / 2;
        
        CGRect insetContentRect = CGRectInset(nodeRect, xInset, yInset);
        
        SKRange *xRange = [SKRange rangeWithLowerLimit:CGRectGetMinX(insetContentRect) upperLimit:CGRectGetMaxX(insetContentRect)];
        SKRange *yRange = [SKRange rangeWithLowerLimit:CGRectGetMinY(insetContentRect) upperLimit:CGRectGetMaxY(insetContentRect)];
        
        SKConstraint *nodeEdgeConstraint = [SKConstraint positionX:xRange Y:yRange];
        
        self.camera.constraints = @[targetConstraint, nodeEdgeConstraint];
    }
}

@end
