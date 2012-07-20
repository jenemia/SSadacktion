//
//  AppDelegate.h
//  SSadacktion
//
//  Created by Soohyun Kim on 12. 7. 20..
//  Copyright rlatngus0333@naver.com 2012년. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
