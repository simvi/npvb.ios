//
//  MembersNavigationController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "MembersNavigationController.h"

@implementation MembersNavigationController

@synthesize viewController;

- (id)initNavigationController {
	
	self.viewController = [[MembersViewController alloc] init];
	
	if (self = [super initWithRootViewController:viewController]) {
		
        // Yellow color
        [[self navigationBar] setTranslucent:NO];
        [[self navigationBar] setBarTintColor:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]];
        
	}
	
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
	
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[viewController release];
	
    [super dealloc];
}


@end
