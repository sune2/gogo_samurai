//
//  CCUIViewWrapper.h
//  samurai
//
//  Created by CA2015 on 13/09/11.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "cocos2d.h"

@interface CCUIViewWrapper : CCSprite
{
    UIView *uiItem;
    float rotation;
}

@property (nonatomic, retain) UIView *uiItem;

+ (id) wrapperForUIView:(UIView*)ui;
- (id) initForUIView:(UIView*)ui;

- (void) updateUIViewTransform;

@end

