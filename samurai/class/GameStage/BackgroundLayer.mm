//
//  BackgroundLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/05.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
-(id)init
{
    self = [super init];
    if (self) {
        self.touchEnabled = NO;
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
        for (int i=0; i<3; i++) {
            _bgSprite[i] = [CCSprite spriteWithFile:@"bg.jpg"];
            _bgSprite[i].anchorPoint = ccp(0,0);
            _bgSprite[i].position = ccp(640*i, 0);
            _bgSprite[i].scale = 640.0 / _bgSprite[i].contentSize.width;
//            [self addChild:_bgSprite[i]];

            CCAction* move = [CCMoveTo actionWithDuration:3*(i+1) position:ccp(-640, 0)];
            [_bgSprite[i] runAction:move];
        }
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4BFromccc4F(ccc4FFromccc3B(ccGRAY))];
        [self addChild:background];
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
    for (int i=0; i<3; i++) {
        if (_bgSprite[i].position.x + 640 <= 0) {
            _bgSprite[i].position = ccp(_bgSprite[(i+2)%3].position.x + 640,
                                        _bgSprite[i].position.y);
            CCAction* move = [CCMoveTo actionWithDuration:9 position:ccp(-640, 0)];
            [_bgSprite[i] runAction:move];
        }
    }
}

@end
