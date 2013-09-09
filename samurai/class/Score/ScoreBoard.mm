//
//  ScoreBoard.m
//  samurai
//
//  Created by CA2015 on 13/09/09.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "ScoreBoard.h"

@implementation ScoreBoard

+ (ScoreBoard *) scene
{
    ScoreBoard* scene = [ScoreBoard node];
    scene.sLayer = [ScoreLayer node];
    [scene addChild:scene.sLayer];
    return scene;
}


@end
