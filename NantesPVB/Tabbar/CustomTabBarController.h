//
//  CustomTabBarController.h
//  DarwinAwards
//
//  Created by Simon Viaud on 9/11/11.
//  Copyright 2011 Simon Viaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarItem.h"

#define kTabBarHeight				49.0
#define kTabBarItemsWidth			80.0 // 136 larg
#define kTabBarItemsHeight			44.0 // 118 hau
#define kTabBarItemsVerticalOffset	3.0
#define kTabBarRealSize             49.0


@interface CustomTabBarController : UIViewController {
	
	UIView							*tabBar;
	NSMutableArray					*viewControllers;
	id<UITabBarControllerDelegate>	delegate;
	UIViewController				*selectedViewController;
	NSUInteger						selectedIndex;
	BOOL							isAlreadyLoaded;
	UIImageView						*backgroundImageView;
	UIInterfaceOrientation			orientation;
}

@property (nonatomic, retain) UIView							*tabBar;
@property (nonatomic, copy) NSMutableArray						*viewControllers;
@property (nonatomic, assign) id<UITabBarControllerDelegate>	delegate;
@property (nonatomic, assign) UIViewController					*selectedViewController;
@property (nonatomic) NSUInteger								selectedIndex;
@property (nonatomic, retain) UIImageView						*backgroundImageView;
@property (nonatomic) UIInterfaceOrientation					orientation;

- (void)selectViewController:(id)sender;
- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBar;
//- (CGRect)getReelRect;
//- (CGRect)getReelRectForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientationParam;

@end
