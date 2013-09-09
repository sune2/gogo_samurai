//
//  ScoreBoard.h
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "ScoreLayer.h"

@interface ScoreBoard : CCScene
{
    
}
@property(nonatomic, strong) ScoreLayer* sLayer;
+ (ScoreBoard *) scene;
@end
