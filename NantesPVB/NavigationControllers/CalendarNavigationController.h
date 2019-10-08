//
//  CalendatNavigationController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewController.h"

@interface CalendarNavigationController : UINavigationController {
	CalendarViewController *viewController;
}

@property (nonatomic, retain) CalendarViewController *viewController;

- (id)initNavigationController;

@end
