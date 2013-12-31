//
//  TextParticle.m
//  samurai
//
//  Created by kz on 13/12/30.
//  Copyright 2013年 gogo-samurai. All rights reserved.
//

#import "TextParticle.h"
#import "Define.h"

@implementation TextParticle

- (id)initWithInt:(int)sc {
    NSString* text = [NSString stringWithFormat:@"%d", sc];
    self = [super initWithString:text fontName:@"Marker Felt" fontSize:15];
    if (self) {
        self.color = ccc3(0, 255, 0);
        self.opacity = 127;
    }
    return self;
}


- (void)run {
    CCFiniteTimeAction* moveAction = [CCMoveTo actionWithDuration:0.6 position:ccp(self.position.x, self.position.y + 30)];
    CCCallFunc* func = [CCCallFunc actionWithTarget:self selector:@selector(removeText)];

    [self runAction:[CCSequence actions:moveAction, func, nil]];
}

- (void)removeText {
    [self removeFromParent];
}

- (void)setPositionWithBody:(b2Body *)body {
    self.position = ccp(body->GetWorldCenter().x * PTM_RATIO,
                        body->GetWorldCenter().y * PTM_RATIO);
}

@end
