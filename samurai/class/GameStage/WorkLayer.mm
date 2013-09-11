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
        _enemies = [[NSMutableArray alloc] init];
        _life = 3;

        NSString* path = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"plist"];
        _events = [[NSArray alloc] initWithContentsOfFile:path];

        _eventIndex = 0;
        
        [self initPhysics];
        
        [self addNewSamuraiSprite];
        
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

- (void)addNewEnemyWithName:(NSString*)name events:(NSArray*)events params:(NSDictionary*)params {
    Enemy* enemy;
    if ([name isEqualToString:@"ninja"]) {
        enemy = [Ninja ninja];
    } else if ([name isEqualToString:@"rikishi"]) {
        enemy = [Rikishi rikishiWithParams:params];
    } else if ([name isEqualToString:@"date"]) {
        Date* date = [Date date];
        date.samurai = _samurai;
        enemy = (Enemy*)date;
    }
    if (enemy.tag == SpriteTagZako) {
        [enemy initBodyWithWorld:world at:ccp(400, 200)];
    } else {
        [enemy initBodyWithWorld:world at:ccp(300, 200)];
    }
    enemy.events = events;
    enemy.delegate = self;
    [self addChild:enemy z:1];
    [_enemies addObject:enemy];
}

-(BOOL)checkOutOfScreen:(CCSprite*)sprite {
    CGSize _windowSize = [CCDirector sharedDirector].winSize;
    CGPoint pos = ccpSub(sprite.position, sprite.anchorPoint);
    CGSize size = sprite.contentSize;
    BOOL res = pos.x < -size.width - 10 ||
               pos.y < -size.height - 10 ||
               _windowSize.width + 10 < pos.x ||
               _windowSize.height + 10 < pos.y;
    return res;
}

-(void)updateBullets:(ccTime) dt
{
    NSMutableArray* tmpBullets = [[NSMutableArray alloc] init];
    for (Projectile* bullet in _bullets) {
        BOOL isOutOfScreen = [self checkOutOfScreen:bullet];
        if (isOutOfScreen) {
            [bullet removeFromParent];
        } else {
            [tmpBullets addObject:bullet];
        }
    }
    _bullets = tmpBullets;
}

- (void) samuraiTouchObj
{
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    for (b2ContactEdge* contactEdge = _samurai.b2Body->GetContactList();
         contactEdge;
         contactEdge = contactEdge->next) {
        
        if (!contactEdge->contact->IsTouching()) continue;
        b2Body* other = contactEdge->other;
        CCPhysicsSprite* sprite = (CCPhysicsSprite*)other->GetUserData();
        
        if (isSpriteEnemy(sprite)) {
            // サムライ vs 敵
            if (![_samurai isDashing] && ![_samurai isCountering]) {
                [_samurai damaged];
            }
        } else if (sprite.tag == SpriteTagProjectile) {
            // サムライが飛び道具に当たったときの処理
            Projectile* projectile = (Projectile*)sprite;
            if (projectile.owner == ProjectileOwnerEnemy) {
                if ([_samurai isCountering]) {
                    [projectile reflect];
                } else {
                    [_samurai damaged];
                    [arr addObject:projectile];
                }
            }
        } else if (sprite.tag == SpriteTagGround) {
            // サムライが地面と当たったときの処理
        }
    }
    [self removeObjects:arr];
}

- (void)enemyTouchingObj
{
    NSMutableArray* damagedEnemies = [[NSMutableArray alloc] init];


    for (Enemy* enemy in _enemies) {
        NSMutableArray* vanishedProjectiles = [[NSMutableArray alloc] init];
        BOOL damaged = NO;

        for (int i=0; i<[enemy bodiesCount]; ++i) {
            b2Body *body = [enemy getBodyAt:i];
            for (b2ContactEdge* contactEdge = body->GetContactList();
                 contactEdge;
                 contactEdge = contactEdge->next) {
                if (!contactEdge->contact->IsTouching()) continue;
                b2Body* other = contactEdge->other;
                CCPhysicsSprite* sprite = (CCPhysicsSprite*)other->GetUserData();
                
                if (sprite.tag == SpriteTagProjectile) {
                    // 敵が飛び道具に当たったときの処理
                    Projectile* projectile = (Projectile *)sprite;
                    if (projectile.owner == ProjectileOwnerSamurai) {
                        damaged = YES;
                        [vanishedProjectiles addObject:projectile];
                    }
                } else if (sprite.tag == SpriteTagKatana) {
                    if ([_samurai isDashing] || [_samurai isCountering]) {
                        damaged = YES;
                    }
                }
            }
        }
        
        // 地震
        if ([_samurai onGround] && [enemy isEarthquaking]) {
            [_samurai damaged];
        }

        
        if (damaged) {
            [damagedEnemies addObject:enemy];
        }
        [self removeObjects:vanishedProjectiles];
    }
    for (Enemy* enemy in damagedEnemies) {
        [enemy damaged];
    }
}

- (void)katanaTouchingObj
{
    for (b2ContactEdge* contactEdge = _samurai.katanaBody->GetContactList();
         contactEdge;
         contactEdge = contactEdge->next) {
        
        if (!contactEdge->contact->IsTouching()) continue;
        b2Body* other = contactEdge->other;
        CCPhysicsSprite* sprite = (CCPhysicsSprite*)other->GetUserData();
        
        if (sprite.tag == SpriteTagProjectile) {
            // 刀が飛び道具に当たったときの処理
            Projectile* projectile = (Projectile *)sprite;
            if (projectile.owner == ProjectileOwnerEnemy) {
                if ([_samurai isCountering]) {
                    [projectile reflect];
                }
            }
        }
    }
}

-(void)removeObjects: (NSMutableArray*) object
{
    for (CCPhysicsSprite* sprite in object) {
        if ([_bullets containsObject:sprite]) {
            [sprite removeFromParent];
            [_bullets removeObject:sprite];
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

-(void) update: (ccTime) dt
{
    _curTime += dt;

	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

    NSMutableArray* arr = [[NSMutableArray alloc] init];;
    for (Enemy* enemy in _enemies) {
        if ([self checkOutOfScreen:enemy]) {
            [arr addObject:enemy];
        }
    }
    [self removeObjects:arr];

    [self samuraiTouchObj];
    [self enemyTouchingObj];
    [self katanaTouchingObj];

    _life = _samurai.hp;
    _score += 1;


    // イベント処理
    while(_eventIndex<[_events count] && [[[_events objectAtIndex:_eventIndex] objectForKey:@"time"] floatValue] < _curTime) {
        NSArray* events = _events[_eventIndex][@"events"];
        NSDictionary* params = _events[_eventIndex][@"params"];
        [self addNewEnemyWithName:_events[_eventIndex][@"name"] events:events params:params];
        _eventIndex++;
    }

}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] >= 2) return;
    UITouch* touch = [touches anyObject];
    _touchPos = [[CCDirector sharedDirector] convertTouchToGL:touch];
    _didCommand = NO;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] >= 2) return;
    UITouch* touch = [touches anyObject];
    CGPoint point = [[CCDirector sharedDirector] convertTouchToGL:touch];
    if (ccpDistance(point, _touchPos) > 50) {
        [self doCommandWithPoint1:point Point2:_touchPos];
        _didCommand = YES;
        _touchPos = point;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] >= 2) return;
    if (!_didCommand) {
        [_samurai counter];
    }
}

- (void) doCommandWithPoint1:(CGPoint)p1 Point2:(CGPoint)p2 {
    double moveAngle = atan2(p1.y - p2.y, p1.x - p2.x) * (180 / M_PI);
    
    int dir = [self sliceDirection:moveAngle];
    if (dir == 0) {
        // Right
        [_samurai dashSlice];
    } else if (dir == 1) {
        // Up
        [_samurai jump];
    } else if (dir == 2) {
        //Left
        [_samurai modoru];
    } else {
        //Down
        [_samurai rakka];
    }
}

- (int) sliceDirection:(double)angle
{
    if (-45 <= angle && angle < 45) {
        return 0;
    } else if (45 <= angle && angle < 135) {
        return 1;
    } else if (-135 <= angle && angle < -45) {
        return 3;
    } else {
        return 2;
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
//	flags += b2Draw::e_shapeBit;
//    flags += b2Draw::e_jointBit;
//    flags += b2Draw::e_aabbBit;
//    flags += b2Draw::e_pairBit;
//    flags += b2Draw::e_centerOfMassBit;
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
	
	groundBox.Set(b2Vec2(-10,0), b2Vec2(s.width/PTM_RATIO+10,0));
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


// protocol

- (void)generatedProjectile:(Projectile *)projectile {
    [self addChild:projectile z:2];
    [_bullets addObject:projectile];
}


- (void)enemyDied:(Enemy *)enemy {
    if (enemy.tag == SpriteTagBoss) _clear = YES;
    assert([_enemies containsObject:enemy]);
    [_enemies removeObject:enemy];
    [enemy removeFromParent];
    self.score += 1000;
}

@end
