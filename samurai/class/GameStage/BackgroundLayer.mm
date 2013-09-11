//
//  BackgroundLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "BackgroundLayer.h"

#define kBackgroundWidth 250

@implementation BackgroundLayer
-(id)init
{
    self = [super init];
    if (self) {
        self.touchEnabled = NO;
        
        // 月
        CCSprite* moon = [CCSprite spriteWithFile:@"fullmoon.png"];
        moon.position = ccp(440, 250);
        moon.scale = 0.3 * 800 / moon.contentSize.width;
        moon.opacity = 128;
        [self addChild:moon z:-2];
        
        
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
        for (int i=0; i<4; i++) {
            _bgSprite[i] = [CCSprite spriteWithFile:@"bamboo.png"];
            _bgSprite[i].anchorPoint = ccp(0,0);
            _bgSprite[i].position = ccp((kBackgroundWidth-30)*i, 0);
            _bgSprite[i].scale = MIN(480.0 / _bgSprite[i].contentSize.height,
                                     kBackgroundWidth / _bgSprite[i].contentSize.width);
            [self addChild:_bgSprite[i]];
        }
        CCLayerColor *background = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:background z:-3];
        // 適切な画像が見つかったらコメント外す
        // 辺の長さ2^nの正方画像
        // ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        // [bgImage.texture setTexParameters:&params];
        
//        CCAction* move = [CCMoveBy actionWithDuration:30
//                                             position:ccp(-(10*640 - winSize.width), 0)];
//        [bgImage runAction:move];
//        [self addChild:bgImage];

        [self scheduleUpdate];
    }
    
    return self;
}

- (void)update:(ccTime)delta {
    for (int i=0; i<4; i++) {
        _bgSprite[i].position = ccp(_bgSprite[i].position.x-delta*5*32, _bgSprite[i].position.y);
        if (_bgSprite[i].position.x < -kBackgroundWidth) {
            _bgSprite[i].position = ccp((kBackgroundWidth-30)*3-30, 0);
        }
    }
}

@end
