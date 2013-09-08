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
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* bgImage = [CCSprite spriteWithFile:@"bg.jpg"]; //rect:CGRectMake(0, 0, 1024 * 5, 512)];
        bgImage.anchorPoint = ccp(0,0);
        bgImage.position = CGPointMake(0, -1000);
        bgImage.scale = 10*640.0 / bgImage.contentSize.width;
        
        // 適切な画像が見つかったらコメント外す
        // 辺の長さ2^nの正方画像
        // ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
        // [bgImage.texture setTexParameters:&params];
        
        CCAction* move = [CCMoveBy actionWithDuration:30
                                             position:ccp(-(10*640 - winSize.width), 0)];
        [bgImage runAction:move];
        [self addChild:bgImage];
        
    }
    
    return self;
}
@end
