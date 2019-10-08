//
//  UIImage+Resource.m
//  DarwinAwards
//
//  Created by Simon Viaud on 9/11/11.
//  Copyright 2011 Simon Viaud. All rights reserved.
//


#import "UIImage+Resource.h"

@implementation UIImage (Resource)

// Load image from resources without memory cache
+ (UIImage*)imageWithName:(NSString*)imageName {
	
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
	
	UIImage *image = [[[UIImage alloc] initWithContentsOfFile:imagePath] autorelease];
	[imagePath release];
	[resourcePath release];
	
	return image;
}

@end