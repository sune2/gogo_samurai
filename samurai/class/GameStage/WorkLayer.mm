//
//  WorkLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "WorkLayer.h"

@implementation WorkLayer

-(id)init
{
    self = [super init];
    if (self) {
        
		self.touchEnabled = YES;
		// CGSize s = [CCDirector sharedDirector].winSize;
        _score = 0;
        _bullets = [[NSMutableArray alloc] init];
        _zakos = [[NSMutableArray alloc] init];
        
        [self initPhysics];
        
        [self addNewSamuraiSprite];
        
//        [self addNewNinjaSprite];[self addNewNinjaSprite];[self addNewNinjaSprite];

        [self addNewRikishi];
        
        [self scheduleUpdate];
        
    }
    
    return self;
}

-(void)addNewSamuraiSprite
{
    _samurai = [Samurai samurai];
    [_samurai initBodyWithWorld:world at:ccp(32, 0)];
    _samurai.tag = SpriteTagSamurai;
    
    [self addChild:_samurai z:1];
}

-(void)addNewNinjaSprite
{
    if ([_zakos count] >= 10) return;
    Ninja* ninja = [Ninja ninja];
    [ninja initBodyWithWorld:world at:ccp(400, 200)];
    ninja.tag = SpriteTagEnemy;
    
    [self addChild:ninja z:1];
    [_zakos addObject:ninja];
}

-(void)addNewRikishi
{
    _rikishi = [Rikishi rikishi];
    [_rikishi initBodyWithWorld:world at:ccp(400,200)];
    _rikishi.tag = SpriteTagBoss;
    _rikishi.delegate = self;
    [self addChild:_rikishi z:1];
}

-(void)addNewBulletSprite:(Ninja*)ninja
{
    if ([_bullets count] >= 10) return;
    Projectile* bullet = [ninja makeBullet];
    bullet.tag = SpriteTagProjectile;
    [self addChild:bullet z:2];
    [_bullets addObject:bullet];
}

- (void)addRikishiBullet
{
    if ([_bullets count] >= 10) return;
    if (rand()% 2 == 0) {
        [_rikishi makeGanko];
    } else {
        [_rikishi makeShiko];
    }
}

- (void)generatedProjectile:(Projectile *)projectile {
    [self addChild:projectile z:2];
    [_bullets addObject:projectile];
}

-(BOOL)checkOutOfScreen:(CCSprite*)sprite {
    CGSize _windowSize = [CCDirector sharedDirector].winSize;
    CGPoint pos = ccpSub(sprite.position, sprite.anchorPoint);
    CGSize size = sprite.contentSize;
    BOOL res = pos.x < (- size.width) / 2 ||
               pos.y < (- size.height) / 2 ||
               (_windowSize.width + size.width / 2) < pos.x ||
               (_windowSize.height + size.height / 2) < pos.y;
    return res;
}

-(void)updateBullets:(ccTime) dt
{
    NSMutableArray* tmpBullets = [[NSMutableArray alloc] init];
    for (Projectile* bullet in _bullets) {
        BOOL isOutOfScreen = [self checkOutOfScreen:bullet];
        BOOL hitSomeone = [self hitWithProjectile:bullet];
        
        if (isOutOfScreen || hitSomeone) {
            [bullet removeFromParent];
            world->DestroyBody(bullet.b2Body);
        } else {
            [tmpBullets addObject:bullet];
        }
    }
    _bullets = tmpBullets;
    
    for (Projectile* bullet in _bullets) {
        [bullet update:dt];
    }

}

-(BOOL)hitWithProjectile:(Projectile*) bullet
{
    for (b2ContactEdge* contactEdge = bullet.b2Body->GetContactList();
         contactEdge;
         contactEdge = contactEdge->next)
    {
        if (!contactEdge->contact->IsTouching()) continue;
        b2Body* other = contactEdge->other;
        CCSprite* sprite = (CCPhysicsSprite*)other->GetUserData();
        if (sprite.tag == SpriteTagSamurai && bullet.owner == ProjectileOwnerEnemy) {
            // 手裏剣とサムライがあたったときの処理
            _samurai.hp--;
            [self generateParticleAt:bullet.position];
            
            return YES;
        } else if (sprite.tag == SpriteTagEnemy && bullet.owner == ProjectileOwnerSamurai) {
            NSMutableArray* arr = [[NSMutableArray alloc] init];
            [arr addObject:sprite];
            [self removeEnemies:arr];
            return YES;
        }
    }
    return NO;
}

-(void)generateParticleAt:(CGPoint)position
{
    CCParticleSystem* particle = [CCParticleExplosion node];
    particle.life = 0.01;
    particle.duration = 0;
    particle.speed = 2.0;
    particle.autoRemoveOnFinish = YES;
    particle.position = position;
    [self addChild:particle z:3];
}

-(void)attackOnEnemy
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (b2ContactEdge* contactEdge = _samurai.katanaBody->GetContactList();
         contactEdge;
         contactEdge = contactEdge->next)
    {
        if (!contactEdge->contact->IsTouching()) continue;
        b2Body* other = contactEdge->other;
        CCPhysicsSprite* sprite = (CCPhysicsSprite*)other->GetUserData();
        if (sprite.tag == SpriteTagEnemy) {
            if ([_samurai isDashing]) {
                [self generateParticleAt:ccp(_samurai.katanaBody->GetWorldCenter().x*PTM_RATIO,
                                             _samurai.katanaBody->GetWorldCenter().y*PTM_RATIO)];
                [arr addObject:sprite];
                _score += 100;
            } else {
                _samurai.hp--;
            }
        } else if (sprite.tag == SpriteTagProjectile && [_samurai isCountering]) {
            Projectile* projectile = (Projectile*)sprite;
            if (projectile.owner == ProjectileOwnerEnemy) {
                [projectile reflect];
            }
        }
    }
    
    [self removeEnemies:arr];

}

-(void)removeEnemies: (NSMutableArray*) enemies
{
    for (CCPhysicsSprite* sprite in enemies) {
        if ([_zakos containsObject:sprite]) {
            world->DestroyBody(sprite.b2Body);
            [sprite removeFromParent];
            [_zakos removeObject:sprite];
        }
    }
}

-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

-(NSInteger)score
{
    return _score;
}

-(void) update: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    [_samurai update:dt];


    NSMutableArray* arr = [[NSMutableArray alloc] init];;
    for (Zako* zako in _zakos) {
        if (zako.b2Body->GetPosition().y < 1) {
            zako.b2Body->SetLinearVelocity(b2Vec2(-5,zako.b2Body->GetLinearVelocity().y));
        }
        if ([self checkOutOfScreen:zako]) {
            [arr addObject:zako];
        }

        [zako update:dt];
        if (rand() % 60 == 0) {
            [self addNewBulletSprite:(Ninja*)zako];
        }
    }
    [self removeEnemies:arr];

    [self updateBullets:dt];
    [self attackOnEnemy];
    [_rikishi update:dt];
    if (rand() % 60 == 0) {
        [self addRikishiBullet];
    }

    if (rand() % 100 == 0) {
        [self addNewNinjaSprite];
    }

}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] >= 2) return;
    UITouch* touch = [touches anyObject];
    _touchPos = [[CCDirector sharedDirector] convertTouchToGL:touch];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    for (Zako* zako in _zakos) {
//        world->DestroyBody(zako.b2Body);
//        [zako removeFromParent];
//    }
    
    if ([touches count] >= 2) return;
    UITouch* touch = [touches anyObject];
    CGPoint point = [[CCDirector sharedDirector] convertTouchToGL:touch];
    
    BOOL isSliced = ccpDistance(point, _touchPos) > 10;
    double moveAngle = atan2(point.y - _touchPos.y, point.x - _touchPos.x) * (180 / M_PI);

    BOOL isMovedToUp = 45 < moveAngle && moveAngle < 180;
    BOOL isMovedToRight = (-90 < moveAngle && moveAngle <= 45);

    if (isSliced) {
        if(isMovedToRight) {
            [_samurai dashSlice];
        } else if (isMovedToUp) {
            [_samurai jump];
        }
    } else {
        [_samurai counter];
    }
}

-(void) initPhysics
{
    // コピペ
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, kGravityPower);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	b2Fixture* fixture = groundBody->CreateFixture(&groundBox,0);
    CCNode* groundNode = [[CCNode alloc] init];
    groundNode.tag = 10;
    fixture->SetUserData(groundNode);
	
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();

}

@end
