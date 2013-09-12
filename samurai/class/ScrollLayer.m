//
//  ScrollLayer.m
//  samurai
//
//  Created by CA2015 on 13/09/12.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

//
// ScrollLayer
//
// (c)2010 hommebrew.com
//

#import "ScrollLayer.h"

@implementation ScrollLayer

+(id) scene
{
    CCScene *scene = [CCScene node];
    ScrollLayer *layer = [ScrollLayer node];
    [scene addChild: layer];
    return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        
        //初期設定
        CGSize s = [[CCDirector sharedDirector] winSize];
        _touchEnabled = YES;
        isDragging = NO;
        lastX = 0.0f;
        xVel = 0.0f;
        contentWidth = s.width * 1.0;  //page
        currentPage = 0;
        scrollLayer = [[CCLayer alloc] init];
        scrollLayer.anchorPoint = ccp(0, 0);
        scrollLayer.position = ccp(0, 0);
        [self addChild:scrollLayer];
        [self schedule:@selector(moveTick:) interval:0.01f];
        
    }
    return self;
}

- (void) addScrollChild:(CCNode*)n
{
    [scrollLayer addChild:n];
}

- (void) changeContentWidth:(int)w
{
    contentWidth = w;
}

- (void) moveTick: (ccTime)dt
{
    float friction = 0.2f;
    CGSize s = [[CCDirector sharedDirector] winSize];
    if (!isDragging)
    {
        xVel *= friction;
        CGPoint pos = scrollLayer.position;
        
        pos.x = MAX(-contentWidth + s.width, pos.x);
        pos.x = MIN(0, pos.x);
        
        //座標で次のページを決定
        //currentPage = abs(rint(pos.x/s.width));
        
        //ドラッグ開始時からの距離で次のページを決定
        if(startPos.x-50 > pos.x) {
            currentPage = nowPage+1;
            [self.delegate scrollPageChanged:currentPage];
        } else if(startPos.x+50 < pos.x) {
            currentPage = nowPage-1;
            [self.delegate scrollPageChanged:currentPage];
        }
        
        pos.x -= ((currentPage*s.width)+pos.x)*friction;
        
        scrollLayer.position = pos;
    }
    else {
        xVel = (scrollLayer.position.x - lastX)/2.0;
        lastX = scrollLayer.position.x;
    }
}

- (void) setCurrentPage:(int)page
{
}

- (void) ccTouchesBegan: (NSSet *)touches withEvent: (UIEvent *)event {
}

- (void) ccTouchesMoved: (NSSet *)touches withEvent: (UIEvent *)event {
    
    float margin = 0;
    CGSize s = [[CCDirector sharedDirector] winSize];
    UITouch *touch = [touches anyObject];
    
    // simple position update
    CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    CGPoint nowPosition = scrollLayer.position;
    
    if(!isDragging) {
        startPos = scrollLayer.position;
        nowPage = abs(rint(nowPosition.x/s.width));
        isDragging = YES;
    }
    
    nowPosition.x += (b.x - a.x);

    nowPosition.x = MAX(-contentWidth + s.width - margin, nowPosition.x);
    nowPosition.x = MIN(margin, nowPosition.x);
    scrollLayer.position = nowPosition;
    
}

- (void) ccTouchesEnded: (NSSet *)touches withEvent: (UIEvent *)event {
    isDragging = NO;
}

- (void) dealloc
{
    [super dealloc];
}
@end