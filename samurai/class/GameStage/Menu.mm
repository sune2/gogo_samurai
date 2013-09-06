//
//  Menu.m
//  samurai
//
//  Created by CA2015 on 13/09/06.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import "Menu.h"

@implementation Menu

-(id)init
{
    self = [super init];
    if (self) {
        self.touchEnabled = NO;
        [self createMenu];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)createMenu
{
    // Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		[[CCDirector sharedDirector] replaceScene: [GameStage scene]];
	}];
    
    int score = 0;
    NSString* scoreStr = [NSString stringWithFormat:@"%d", score];
    CCMenuItemLabel *scoreLabel = [CCMenuItemFont itemWithString:scoreStr];
    
    
    CCMenu *menu = [CCMenu menuWithItems:scoreLabel, reset, nil];
	
	[menu alignItemsVertically];
	// menu.anchorPoint = ccp(0, 0);
    
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height-30)];
	
	
	[self addChild: menu z:-1];
}

@end
