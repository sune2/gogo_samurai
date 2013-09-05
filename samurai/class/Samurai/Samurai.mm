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

- (void)jump {
    self.b2Body->ApplyLinearImpulse(b2Vec2(3,3), b2Vec2(0,0));
}

@end
