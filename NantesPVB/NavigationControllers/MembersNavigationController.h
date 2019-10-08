//
//  MembersNavigationController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MembersViewController.h"

@interface MembersNavigationController : UINavigationController {
	MembersViewController *viewController;
}

@property (nonatomic, retain) MembersViewController *viewController;

- (id)initNavigationController;

@end
