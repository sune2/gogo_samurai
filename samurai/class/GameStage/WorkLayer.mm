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
        _bullets = [[NSMutableArray alloc] init];
        _zakos = [[NSMutableArray alloc] init];
        
        [self initPhysics];
        
        [self addNewSamuraiSprite];
        [self addNewNinjaSprite];
        
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
    Ninja* ninja = [Ninja ninja];
    [ninja initBodyWithWorld:world at:ccp(256, 0)];
    ninja.tag = SpriteTagEnemy;
    
    [self addChild:ninja z:1];
    [_zakos addObject:ninja];
}

-(void)addNewBulletSprite
{
    Ninja* ninja = [_zakos objectAtIndex:0];
    Projectile* bullet = [ninja makeBullet];
    [self addChild:bullet z:2];
    [_bullets addObject:bullet];
}

-(void)updateBullets:(ccTime) dt
{
    CGSize windowSize = [CCDirector sharedDirector].winSize;
    NSMutableArray* tmpBullets = [[NSMutableArray alloc] init];
    for (Projectile* bullet in _bullets) {
        CGPoint bulletPos = bullet.position;
        CGSize bulletSize = bullet.contentSize;
        BOOL isOutOfScreen = bulletPos.x < (- bulletSize.width) / 2 ||
                             bulletPos.y < (- bulletSize.height) / 2 ||
                             (windowSize.width + bulletSize.width / 2) < bulletPos.x ||
                             (windowSize.height + bulletSize.height / 2) < bulletPos.y;
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
        CCSprite* sprite = (CCSprite*)other->GetUserData();
        if (sprite.tag == SpriteTagSamurai) {
            // 手裏剣とサムライがあたったときの処理
            // _samurai.hp--;
            CCParticleSystem* particle = [CCParticleExplosion node];
            particle.life = 0.01;
            particle.duration = 0;
            particle.speed = 2.0;
            particle.autoRemoveOnFinish = YES;
            particle.position = bullet.position;
            [self addChild:particle z:3];
            
            return YES;
        }
    }
    return NO;
}


-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

-(void) update: (ccTime) dt
{
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    [_samurai update:dt];
    [self updateBullets:dt];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] >= 2) return;
    UITouch* touch = [touches anyObject];
    _touchPos = [[CCDirector sharedDirector] convertTouchToGL:touch];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
        [self addNewBulletSprite];
    }
}

-(void) initPhysics
{
    // コピペ
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
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
