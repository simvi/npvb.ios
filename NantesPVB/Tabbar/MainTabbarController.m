//
//  MainTabbarController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "MainTabbarController.h"

@implementation MainTabbarController

@synthesize homeNavigationController;
@synthesize calendarNavigationController;
@synthesize membersNavigationController; 
@synthesize othersNavigationController;  

- (id)initTabbarController {
	
	if (self = [super init]) {
		
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
		// Initialisation of all navigation controllers
        
        self.homeNavigationController       = [[HomeNavigationController alloc] initNavigationController];
        self.calendarNavigationController	= [[CalendarNavigationController alloc] initNavigationController];
        self.membersNavigationController     = [[MembersNavigationController alloc] initNavigationController];
        self.othersNavigationController      = [[OthersNavigationController alloc] initNavigationController];
        
		// Making an array with all controllers in the tabBar
		NSMutableArray* tabControllers = [[NSMutableArray alloc] initWithObjects:
										  homeNavigationController,
										  calendarNavigationController,
										  membersNavigationController,
                                          othersNavigationController,
										  nil];
		
		// Adding of controllers in tabBar
		[self setViewControllers:tabControllers];
		//[self setDelegate:self];
		
		[tabControllers release];		
	}
	
	return self;
	
}

- (void)selectViewController:(id)sender {
	
	if ([sender tag] == 2 
		&& selectedIndex == 2) {
		return;
	}
	[super selectViewController:sender];
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	if (![viewController isKindOfClass:[HomeNavigationController class]])
		[(UINavigationController*) viewController popToRootViewControllerAnimated:NO];
	else {
		if ([[(UINavigationController*) viewController viewControllers] count] > 1) {
			[(UINavigationController*) viewController popToViewController:[[(UINavigationController*) viewController viewControllers] objectAtIndex:1] animated:NO];
		}
	}
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)dealloc {
    
	[homeNavigationController       release];
    [calendarNavigationController    release];
    [membersNavigationController     release];
    [othersNavigationController     release];
	
    [super							dealloc];
}
@end
