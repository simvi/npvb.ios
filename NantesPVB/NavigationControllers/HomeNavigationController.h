//
//  HomeNavigationController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface HomeNavigationController : UINavigationController {
	HomeViewController *viewController;
}

@property (nonatomic, retain) HomeViewController *viewController;

- (id)initNavigationController;

@end
