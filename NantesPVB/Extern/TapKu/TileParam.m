//
//  TileParam.m
//  Nantes PVB
//
//  Created by Damien Traille on 21/06/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import "TileParam.h"

@implementation TileParam

@synthesize backColor;
@synthesize arrayOfLine;
@synthesize day;

- (id)initWithBackColor:(NSString*)backColorParam
            arrayOfLine:(NSArray*)arrayOfLineParam {
	
	if (self = [super init]) {
		
		self.backColor = backColorParam;
		self.arrayOfLine = arrayOfLineParam;
		
	}
	return self;
	
}

- (void)dealloc {
	[day release];
	[backColor release];
	[arrayOfLine release];
	[super dealloc];
	
}

@end