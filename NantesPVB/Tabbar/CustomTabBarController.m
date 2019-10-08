//
//  CustomTabBarController.m
//  DarwinAwards
//
//  Created by Simon Viaud on 9/11/11.
//  Copyright 2011 Simon Viaud. All rights reserved.
//

#import "CustomTabBarController.h"

@implementation CustomTabBarController

@synthesize tabBar;
@synthesize viewControllers;
@synthesize delegate;
@synthesize selectedViewController;
@synthesize selectedIndex;
@synthesize backgroundImageView;
@synthesize orientation;

CGRect viewFrame;

- (id)init {
	if (self = [super init]) {
		self.selectedIndex = 0;
		isAlreadyLoaded = NO;
		[[self view]  setBackgroundColor:[UIColor darkGrayColor]];
	}
	return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setInsetsLayoutMarginsFromSafeArea:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
	if (!isAlreadyLoaded) {
		// Adding the current view
		CGRect frame = [[self view] frame];
        
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        CGFloat bottomPadding = window.safeAreaInsets.bottom;

		viewFrame = CGRectMake(frame.origin.x, 0.0, frame.size.width, frame.size.height - kTabBarRealSize - bottomPadding);
		
		selectedViewController = [viewControllers objectAtIndex:selectedIndex];
		UIView *currentView = [selectedViewController view];
		[currentView setFrame:viewFrame];
		[[self view] addSubview:currentView];
        
		// Setting the TabBar
		self.tabBar = [[UIView alloc] initWithFrame:CGRectMake(0.0, frame.size.height - kTabBarHeight - bottomPadding, self.view.frame.size.width, kTabBarHeight + bottomPadding)];
		[tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
		[tabBar setBackgroundColor:[UIColor clearColor]];
		[[self view] addSubview:tabBar];
		[tabBar release];
		
		// Setting the background
		self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kTabBarHeight + bottomPadding)];
		[backgroundImageView setBackgroundColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
		//[backgroundImageView setImageName:@"bkgd_tabbar.png"];
		[backgroundImageView setContentMode:(UIViewContentModeScaleToFill)];
		[tabBar addSubview:backgroundImageView];
		[backgroundImageView release];
		
		float spaceWidth = (self.view.frame.size.width-(kTabBarItemsWidth * [viewControllers count]))/4;
        //(260.0 - (kTabBarItemsWidth * [viewControllers count])) / (2 * [viewControllers count]);
		
		// Adding the tabBar items
		for (int index = 0; index < [viewControllers count]; index++) {
			
			[[viewControllers objectAtIndex:index] viewDidAppear:NO];
			
			int xPosition = index * (kTabBarItemsWidth + 2 + spaceWidth);
			
			CGRect tabBarRect = CGRectMake(xPosition, kTabBarItemsVerticalOffset, kTabBarItemsWidth, kTabBarItemsHeight);
			CustomTabBarItem *tabBarButton = [[CustomTabBarItem alloc] initWithFrame:tabBarRect];
			NSString *ongletPath = [NSString stringWithFormat:@"onglet_%i.png", index];
			[tabBarButton setImageName:ongletPath forState:UIControlStateNormal];
			NSString *ongletSelectedPath = [NSString stringWithFormat:@"onglet_%i_selected.png", index];
			[tabBarButton setImageName:ongletSelectedPath forState:UIControlStateSelected];
			[tabBarButton addTarget:self action:@selector(selectViewController:) forControlEvents:UIControlEventTouchUpInside];
			[tabBarButton setTag:index];
			[tabBar addSubview:tabBarButton];
			[tabBarButton release];
			
			if (index == selectedIndex) {
				[tabBarButton setSelected:YES];
			} else {
				[tabBarButton setSelected:NO];
			}
		}
		isAlreadyLoaded = YES;
	}
	
	[super viewWillAppear:animated];
	
}

- (void)setSelectedIndex:(NSUInteger)index {
	
	[self selectViewController:[tabBar viewWithTag:index]];
	
}

- (void)selectViewController:(id)sender {

//    [self shouldAutorotateToInterfaceOrientation:[[UIDevice currentDevice] orientation]];
	
	if ([sender tag] == selectedIndex) {
		[(UINavigationController*)selectedViewController popToRootViewControllerAnimated:YES];		
		return;
	}
	
	// Removing the old view
	[(UIViewController*)[viewControllers objectAtIndex:selectedIndex] viewWillDisappear:NO];
	UIView *currentView = [[viewControllers objectAtIndex:selectedIndex] view];
	[currentView removeFromSuperview];
	// Changing the selected
	selectedIndex = [sender tag];
	selectedViewController = [viewControllers objectAtIndex:selectedIndex];
	
	// Adding the new view
	[selectedViewController viewWillAppear:YES];

    //    CGRect frame = [self getReelRect];
	//CGRect viewFrame = CGRectMake(frame.origin.x, 0.0, frame.size.width, frame.size.height - kTabBarRealSize);
	
	UIView *newView = [selectedViewController view];
	[newView setFrame:viewFrame];
	[[self view] addSubview:newView];
	
	[selectedViewController viewDidAppear:NO];
	
	
	// Changing the tabBar Items state
	for (UIView *view in [tabBar subviews]) {
		if ([view isKindOfClass:[CustomTabBarItem class]]) {
			[(CustomTabBarItem*)view setSelected:([view tag] == selectedIndex)];
		}
	}
	
	if ([[(UITabBarController*)self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
		[[(UITabBarController*)self delegate] tabBarController:(UITabBarController*)self didSelectViewController:selectedViewController];		
	}
    
    [[self view] bringSubviewToFront:tabBar];

}

- (void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBar {
	
	CGRect frame = [[self view] frame];
	UIView *currentView = [[viewControllers objectAtIndex:selectedIndex] view];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:UINavigationControllerHideShowBarDuration];
	if (hidesBottomBar) {
		[tabBar setFrame:CGRectMake(0.0, frame.size.height, frame.size.width, kTabBarHeight)];
		[UIView commitAnimations];
		[currentView setFrame:CGRectMake(frame.origin.x, 0.0, frame.size.width, frame.size.height)];
	} else {
		[tabBar setFrame:CGRectMake(0.0, frame.size.height - kTabBarHeight, frame.size.width, kTabBarHeight)];
		[UIView commitAnimations];
		[currentView setFrame:CGRectMake(frame.origin.x, 0.0, frame.size.width, frame.size.height - kTabBarHeight)];
	}
}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

	/*
	 switch ([[UIDevice currentDevice] orientation]) {
	 case UIInterfaceOrientationLandscapeLeft:
	 case UIInterfaceOrientationLandscapeRight:
	 case UIInterfaceOrientationPortrait:
	 case UIInterfaceOrientationPortraitUpsideDown:
	 orientation = interfaceOrientation;
	 default:
	 break;
	 }
	 */
	
//    return UIInterfaceOrientationPortrait;
	//En fonction de la frame de la tab bar on redispose les composants
	/*CGRect frame = [self getReelRectForInterfaceOrientation:orientation];
	 
	 
	 
	 [backgroundImageView setFrame:CGRectMake(0.0, 0.0, frame.size.width, kTabBarHeight)];
	 
	 int pos = 0;
	 float spaceWidth = (frame.size.width - (kTabBarItemsWidth * [viewControllers count])) / (2 * [viewControllers count]);
	 
	 
	 for (UIView *subview in [tabBar subviews]) {
	 if ([subview isKindOfClass:[CustomTabBarItem class]]) {
	 int xPosition = pos * (kTabBarItemsWidth + 2 * spaceWidth) + spaceWidth;
	 
	 CustomTabBarItem *button = (CustomTabBarItem*)subview;
	 [button setFrame:CGRectMake(xPosition, kTabBarItemsVerticalOffset, kTabBarItemsWidth, kTabBarItemsHeight)];
	 pos++;
	 }
	 }
	 */
	
//    return NO;
//}

//- (CGRect)getReelRect {
//
//    switch (orientation) {
//        case UIInterfaceOrientationLandscapeLeft:
//        case UIInterfaceOrientationLandscapeRight:
//        {
//            CGRect rect = [[self view] frame];
//            return CGRectMake(0.0, 20.0, rect.size.height, rect.size.width);
//        }
//            break;
//        case UIInterfaceOrientationPortrait:
//        case UIInterfaceOrientationPortraitUpsideDown:
//        default:
//            return [[self view] frame];
//            break;
//    }
//}

//- (CGRect)getReelRectForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientationParam {

	/*switch (interfaceOrientationParam) {
	 case UIInterfaceOrientationLandscapeLeft:
	 case UIInterfaceOrientationLandscapeRight:
	 {
	 CGRect rect = [[self view] frame];
	 if (rect.size.height == 1024) {
	 return CGRectMake(0.0, 20.0,  rect.size.height, rect.size.width);
	 } else {
	 return CGRectMake(0.0, 20.0, rect.size.height+20.0, rect.size.width-20.0);
	 }			
	 }
	 break;
	 case UIInterfaceOrientationPortrait:
	 case UIInterfaceOrientationPortraitUpsideDown:
	 default:
	 {
	 CGRect rect = [[self view] frame];
	 if (rect.size.width == 768) {
	 return CGRectMake(0.0, 20.0, rect.size.width, rect.size.height);
	 } else
	 return CGRectMake(0.0, 20.0, rect.size.width +20, rect.size.height - 20);
	 }	
	 break;
	 
	 }*/
	
//    switch (interfaceOrientationParam) {
//        case UIInterfaceOrientationLandscapeLeft:
//        case UIInterfaceOrientationLandscapeRight:
//        {
//            return CGRectMake(0.0, 20.0,  1024.0, 748.0);
//
//        }
//            break;
//        case UIInterfaceOrientationPortrait:
//        case UIInterfaceOrientationPortraitUpsideDown:
//        default:
//        {
//            return CGRectMake(0.0, 20.0,  768.0, 1004.0);
//        }
//            break;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[tabBar release];
	[viewControllers release];
	[backgroundImageView release];
    [super dealloc];
}

@end
