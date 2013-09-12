//
//  ScrollLayer.h
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

#import "cocos2d.h"

@protocol ScrollLayerDelegate

- (void)scrollPageChanged:(int)page;

@end

@interface ScrollLayer : CCLayer
{
    CCLayer *scrollLayer;
    BOOL isDragging;
    CGPoint startPos;
    int nowPage;
    
    float lastX;
    float lastY;
    float xVel;
    float yVel;
    int contentWidth;
    int contentHeight;
    int currentPage;
    
}

@property(nonatomic, strong)     id<ScrollLayerDelegate> delegate;

+(id) scene;
- (void) setCurrentPage:(int)page;
- (void) changeContentWidth:(int)w;
- (void) addScrollChild:(CCNode*)n;

@end