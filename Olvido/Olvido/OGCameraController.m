//
//  OGCameraNode.m
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import "OGCameraController.h"
#import "OGCollisionBitMask.h"

NSString *const kOGCameraControllerRailsNodeName = @"camera_rails";
NSString *const kOGCameraControllerRailsResetPointsNodeName = @"rails_reset_points";
NSString *const kOGCameraControllerSpawnPointsNodeName = @"spawn_points";
NSString *const kOGCameraControllerMoveActionKey = @"camera_move_action";

@interface OGCameraController ()

@property (nonatomic, weak) SKSpriteNode *rails;

@end

@implementation OGCameraController

- (void)moveCameraToNode:(SKNode *)node duration:(CGFloat)duration
{
    [self resetCameraRails];
    [self.camera removeActionForKey:kOGCameraControllerMoveActionKey];
    
    SKSpriteNode *cameraRails = (SKSpriteNode *) [node childNodeWithName:kOGCameraControllerRailsNodeName];
    self.rails = cameraRails;
    
    CGPoint newPosition;
    
    if (cameraRails)
    {
        newPosition = [node.scene convertPoint:cameraRails.position fromNode:node];
    }
    else
    {
        newPosition = node.position;
    }        
    
    SKAction *cameraMovement = [SKAction moveTo:newPosition duration:duration];
    [self.camera runAction:cameraMovement withKey:kOGCameraControllerMoveActionKey];
}

- (void)update
{
    if (self.rails)
    {
        [self updateRails];
    }
}

- (void)updateRails
{
    CGPoint targetPositionInRails = [self.rails convertPoint:self.target.position
                                                    fromNode:self.rails.scene];
    
    CGFloat newRailsX = self.rails.position.x;
    CGFloat newRailsY = self.rails.position.y;
    
    CGFloat widthOffset = self.rails.size.width / 2.0;
    CGFloat heightOffset = self.rails.size.height / 2.0;
    
    CGFloat dx = fabs(targetPositionInRails.x) - widthOffset;
    
    if (dx > 0.0)
    {
        newRailsX += (targetPositionInRails.x > 0.0) ? dx : -dx;
    }
    
    CGFloat dy = fabs(targetPositionInRails.y) - heightOffset;
    
    if (dy > 0.0)
    {
        newRailsY += (targetPositionInRails.y > 0.0) ? dy : -dy;
    }
    
    self.rails.position = CGPointMake(newRailsX, newRailsY);
    
    [self updateCameraWithRails];
}

- (void)updateCameraWithRails
{
    CGPoint railsPositionInScene = [self.camera.scene convertPoint:self.rails.position
                                                          fromNode:self.rails.parent];
    
    CGRect railsParentRect = self.rails.parent.calculateAccumulatedFrame;
    CGPoint railsParentRectCenter = CGPointMake(CGRectGetMidX(railsParentRect),
                                                CGRectGetMidY(railsParentRect));
    
    CGFloat newCameraX = self.camera.position.x;
    CGFloat newCameraY = self.camera.position.y;
    
    CGSize sceneSize = self.camera.scene.size;
    
    CGFloat dx = railsParentRect.size.width / 2.0 - fabs(railsPositionInScene.x - railsParentRectCenter.x);
    
    if (dx > sceneSize.width / 2.0)
    {
        newCameraX = railsPositionInScene.x;
    }
    
    CGFloat dy = railsParentRect.size.height / 2.0 - fabs(railsPositionInScene.y - railsParentRectCenter.y);
    
    if (dy > sceneSize.height / 2.0)
    {
        newCameraY = railsPositionInScene.y;
    }
    
    CGPoint newCameraPosition = CGPointMake(newCameraX, newCameraY);
    self.camera.position = newCameraPosition;
}

- (void)resetCameraRails
{
    CGFloat minDistance = CGFLOAT_MAX;
    CGPoint possibleResetPoint = CGPointZero;
    
    NSArray *resetPoints = [self.rails.parent childNodeWithName:kOGCameraControllerRailsResetPointsNodeName].children;
    
    for (SKNode *node in resetPoints)
    {
        CGFloat distance = hypot(node.position.x - self.rails.position.x,
                                 node.position.y - self.rails.position.y);
        
        if (distance < minDistance)
        {
            minDistance = distance;
            possibleResetPoint = node.position;
        }
    }
    
    self.rails.position = possibleResetPoint;
    self.rails = nil;
}

@end
