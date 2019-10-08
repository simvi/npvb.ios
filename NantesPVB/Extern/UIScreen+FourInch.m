//
//  UIScreen+FourInch.m
//  ELLE à table
//
//  Created by Luc Plançon on 07/02/09.
//  Copyright 2009 Lagardère Active Digital. All rights reserved.
//  Developed by DPC Interactive.
//

#import "UIScreen+FourInch.h"

@implementation UIScreen (FourInch)

+ (BOOL)isRetina {
    	
	BOOL isRetina = NO;
	
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		
		NSMethodSignature *scaleSignature = [UIScreen instanceMethodSignatureForSelector:@selector(scale)];
		NSInvocation *scaleInvocation = [NSInvocation invocationWithMethodSignature:scaleSignature];
		[scaleInvocation setSelector:@selector(scale)];
		[scaleInvocation setTarget:[UIScreen mainScreen]];
		CGFloat scale;
		[scaleInvocation invoke];
		[scaleInvocation getReturnValue:&scale];
		
		
		isRetina = (scale == 2.0);
	}
	
	return isRetina;
	    
}

+ (BOOL)isFourInches {
    
	NSMutableString *defaultPath = [NSMutableString stringWithString:[[NSBundle mainBundle] resourcePath]];
	[defaultPath appendString:@"/Default-568h@2x.png"];
	
    return ([[UIScreen mainScreen] bounds].size.height == 568.0 &&
            [[NSFileManager defaultManager] fileExistsAtPath:defaultPath]);
    
}

@end
