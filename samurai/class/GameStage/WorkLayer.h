//
//  WorkLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLES-Render.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "Define.h"
#import "Samurai.h"
#import "Zako.h"
#import "Ninja.h"
#import "Projectile.h"
#import "Rikishi.h"
#import "MyParticle.h"

@interface WorkLayer : CCLayer<ProjectileProtocol>
{
    b2World* world;
    GLESDebugDraw *m_debugDraw;
    Samurai* _samurai;
    NSMutableArray* _zakos;
    NSMutableArray* _bullets;
    CGPoint _touchPos;
    Rikishi* _rikishi;
}

@property(assign) int score;
@property(assign) int life;

@end
