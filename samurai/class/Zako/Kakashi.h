//
//  Kakashi.h
//  samurai
//
//  Created by CA2015 on 13/09/12.
//  Copyright (c) 2013年 gogo-samurai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"

@interface Kakashi : Enemy
{
    
}

+ (Kakashi *)kakashi;
+ (Kakashi *)kakashiWithParams: (NSDictionary *)params;

@end
