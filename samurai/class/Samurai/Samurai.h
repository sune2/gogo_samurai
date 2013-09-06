//
//  Samurai.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "CCPhysicsSprite.h"

@interface Samurai : CCPhysicsSprite
{
    BOOL _isJumping;
    CGPoint _initPos;
    b2Body* _katanaBody;
    int _counterCounter;
    int _dashCounter;
}

@property (nonatomic, strong) CCSprite* katana;

+ (Samurai*)samurai;
- (void)initBodyWithWorld:(b2World*)world at:(CGPoint)point;
- (void)jump;
- (void)dashSlice;
- (void)counter;
@end
