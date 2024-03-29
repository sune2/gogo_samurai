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
#import "Ninja.h"
#import "Projectile.h"
#import "Rikishi.h"
#import "Kakashi.h"
#import "Date.h"
#import "MyParticle.h"
#import "TextParticle.h"

@interface WorkLayer : CCLayer<ProjectileProtocol, EnemyProtocol, DateDelegate>
{
    b2World* world;
    GLESDebugDraw *m_debugDraw;
    Samurai* _samurai;
    NSMutableArray* _enemies;
    NSMutableArray* _bullets;
    
    NSMutableSet* _damagedEnemies;
    NSMutableSet* _vanishedProjectiles;

    CGPoint _touchPos;
    BOOL _didCommand;

    NSArray* _events;
    int _eventIndex;

    ccTime _curTime;
    CGSize _winSize;
}

@property(assign) int score;
@property(assign) int life;
@property(readonly) BOOL clear;
@property(assign) NSArray* events;

//- (id)initWithEvents:(NSArray*)events;

@end
