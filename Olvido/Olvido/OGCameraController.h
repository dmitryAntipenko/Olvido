//
//  OGCameraNode.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/8/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface OGCameraController : NSObject

@property (nonatomic, strong) SKCameraNode *camera;
@property (nonatomic, weak) SKNode *target;
@property (nonatomic, assign, getter=isLocked) BOOL locked;

- (void)moveCameraToNode:(SKNode *)node;

- (void)update;

@end
