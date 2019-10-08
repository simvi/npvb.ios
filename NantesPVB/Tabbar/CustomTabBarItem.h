//
//  CustomTabBarItem.h
//  DarwinAwards
//
//  Created by Simon Viaud on 9/11/11.
//  Copyright 2011 Simon Viaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarController.h"

@interface CustomTabBarItem : UIView {
	
	UIImageView	*imageView;
	UIImage		*selectedImage;
	UIImage		*normalImage;
	SEL			selector;
	id			target;
}

@property (nonatomic, retain) UIImageView	*imageView;
@property (nonatomic, retain) UIImage		*selectedImage;
@property (nonatomic, retain) UIImage		*normalImage;

- (void)addTarget:(id)targetParam action:(SEL)actionParam forControlEvents:(UIControlEvents)controlEventsParam;
- (void)setImageName:(NSString*)imageName forState:(UIControlState)stateParam;
- (void)setSelected:(BOOL)selectedParam;

@end
