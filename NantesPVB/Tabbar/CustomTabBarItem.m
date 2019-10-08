//
//  CustomTabBarItem.m
//  DarwinAwards
//
//  Created by Simon Viaud on 9/11/11.
//  Copyright 2011 Simon Viaud. All rights reserved.
//

#import "CustomTabBarItem.h"

@implementation CustomTabBarItem

@synthesize imageView;
@synthesize selectedImage;
@synthesize normalImage;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - kTabBarItemsWidth) / 2, (frame.size.height - kTabBarItemsHeight) / 2, kTabBarItemsWidth, kTabBarItemsHeight)];
		[self addSubview:imageView];
		[imageView release];
		
	}
	return self;
}

- (void)addTarget:(id)targetParam action:(SEL)actionParam forControlEvents:(UIControlEvents)controlEventsParam {
	
	selector = actionParam;
	target = targetParam;
	
}

// Load image from resources without memory cache
- (void)setImageName:(NSString*)imageName forState:(UIControlState)stateParam {
	
	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] retain];
	NSMutableString *imagePath = [[NSMutableString alloc] initWithString:resourcePath];
	[imagePath appendString:@"/"];
	
	BOOL isDoubleScale = NO;
	
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		
		NSMethodSignature *scaleSignature = [UIScreen instanceMethodSignatureForSelector:@selector(scale)];
		NSInvocation *scaleInvocation = [NSInvocation invocationWithMethodSignature:scaleSignature];
		[scaleInvocation setSelector:@selector(scale)];
		[scaleInvocation setTarget:[UIScreen mainScreen]];
		CGFloat scale;
		[scaleInvocation invoke];
		[scaleInvocation getReturnValue:&scale];
		
		
		isDoubleScale = (scale == 2.0);
	}
	
	if (isDoubleScale) {
		
		[imagePath appendString:[imageName stringByDeletingPathExtension]];
		[imagePath appendString:@"@2x."];
		[imagePath appendString:[imageName pathExtension]];
		
		if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])  {
			[imagePath setString:resourcePath];
			[imagePath appendString:@"/"];
			[imagePath appendString:imageName];
		}
		
	} else {
		[imagePath appendString:imageName];
	}
	
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
	if (stateParam == UIControlStateNormal) {
		self.normalImage = image;
	} else {
		self.selectedImage = image;
	}
	[image release];
	[imagePath release];
	[resourcePath release];
	
}

- (void)setSelected:(BOOL)selectedParam {
	if (selectedParam) {
		[imageView setImage:selectedImage];
	} else {
		[imageView setImage:normalImage];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([target respondsToSelector:selector]) 
		[target performSelector:selector withObject:self];
}

- (void)dealloc {
	[imageView release];
	[selectedImage release]; 
	[normalImage release]; 
	[super dealloc];
}


@end
