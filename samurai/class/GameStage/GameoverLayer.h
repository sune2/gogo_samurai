//
//  GameoverLayer.h
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "MenuLayer.h"

@interface GameoverLayer : CCLayer
{
    CGSize _winSize;
}

- (id)initWithScore: (int)score;
+ (id)nodeWithScore: (int)score;

@property (strong) id<MenuLayerDelegate> delegate;
@end
