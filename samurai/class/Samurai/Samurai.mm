//
//  Samurai.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Samurai.h"
#import "../Define.h"
#import "GB2ShapeCache.h"

@implementation Samurai

+ (Samurai*)samurai {
    Samurai *res = [super spriteWithFile:@"samurai.png"];
    res.scale = 116.0 / res.textureRect.size.width;
    [res setPTMRatio:PTM_RATIO];
    return res;
}

- (void)initBodyWithWorld:(b2World *)world at:(CGPoint)point {
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(point.x/self.PTMRatio,point.y/self.PTMRatio);
    bodyDef.fixedRotation = YES;
    
	b2Body *body = world->CreateBody(&bodyDef);
	
    [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"samurai"];
    [self setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"samurai"]];

    [self setB2Body:body];
    _initPos = point;
}

- (BOOL)isMovable {
    if (self.position.x > _initPos.x) return NO;
    for (b2ContactEdge* contactEdge = self.b2Body->GetContactList(); contactEdge;
         contactEdge = contactEdge->next) {
        b2Contact* contact = contactEdge->contact;
        if (contact->IsTouching()) {
            
            b2Fixture *fixture = contact->GetFixtureA();
            CCNode* node = (CCNode*)fixture->GetUserData();
            if (node.tag == 10) {
                return YES;
            }
        }
    }
    return NO;
}


- (void)jump {
    if ([self isMovable]) {
        self.b2Body->ApplyLinearImpulse(b2Vec2(0,50), self.b2Body->GetWorldCenter());
    }
}

- (void)dashSlice {
    if ([self isMovable]) {
        self.position = ccp(self.position.x + 200, self.position.y);
    }
}

- (void)update:(ccTime)delta {
    
    if (self.position.x < _initPos.x) {
        // 戻り過ぎ
        
    } else if (self.position.x > _initPos.x) {
        self.position = ccp(self.position.x-5, self.position.y);
    }
}

@end
