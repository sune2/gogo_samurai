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
#import <Social/Social.h>

@interface GameoverLayer : CCLayer
{
    CGSize _winSize;
    NSString* _path;
    NSMutableArray* _ranking;
    UIViewController* _viewController;
    BOOL _win;
    int _score;
    BOOL _shareButtonPushed;
    NSUserDefaults* _ud;
}

- (id)initWithScore:(int)score result:(BOOL)win;
+ (id)nodeWithScore:(int)score result:(BOOL)win;

@property (strong) id<MenuLayerDelegate> delegate;
@end
