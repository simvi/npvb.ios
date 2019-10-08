//
//  OthersNavigationController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherViewController.h"

@interface OthersNavigationController : UINavigationController {
	OtherViewController *viewController;
}

@property (nonatomic, retain) OtherViewController *viewController;

- (id)initNavigationController;

@end
