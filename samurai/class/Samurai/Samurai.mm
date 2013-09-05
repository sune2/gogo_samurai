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
}

- (BOOL)canJump {
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
    if ([self canJump]) {
        self.b2Body->ApplyLinearImpulse(b2Vec2(0,20), self.b2Body->GetWorldCenter());
    }
}

@end
