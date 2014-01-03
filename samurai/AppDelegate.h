//
//  AppDelegate.h
//  samurai
//
//  Created by CA2015 on 13/09/04.
//  Copyright gogo-samurai 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>
#import <iAd/iAd.h>
#import "GameStage.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate,ADBannerViewDelegate> {
    ADBannerView* _adView;
    BOOL _bannerIsVisible; // 広告表示状態のフラグ

}
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;
	
	CCDirectorIOS	*director_;							// weak ref

 }

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end
