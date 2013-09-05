//
//  Samurai.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Box2D.h"
#import "CCPhysicsSprite.h"

@interface Samurai : CCPhysicsSprite
{
    BOOL _isJumping;
}

+ (Samurai*)samurai;
- (void)initBodyWithWorld:(b2World*)world at:(CGPoint)point;
- (void)jump;

@end
