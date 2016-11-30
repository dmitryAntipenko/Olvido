//
//  OGHUDElement.h
//  Olvido
//
//  Created by Дмитрий Антипенко on 11/29/16.
//  Copyright © 2016 Дмитрий Антипенко. All rights reserved.
//

@class OGHUDNode;

@protocol OGHUDElement <NSObject>

@property (nonatomic, weak) OGHUDNode *hudNode;

- (void)didAddToHUD;

- (void)update;

@end
