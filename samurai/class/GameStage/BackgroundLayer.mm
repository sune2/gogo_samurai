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
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* bgImage = [CCSprite spriteWithFile:@"bg.jpg"];
        bgImage.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:bgImage];
    }
    
    return self;
}
@end
