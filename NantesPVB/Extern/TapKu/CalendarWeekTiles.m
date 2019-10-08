//
//  CalendarWeekTiles.m
//  MaNounou
//
//  Created by Michalak on 03/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarWeekTiles.h"
#import "CalendarWeekTile.h"

@implementation CalendarWeekTiles

@synthesize delegate;

- (id)initWithDays:(NSArray*)daysParam params:(NSArray*)params {

    if ((self = [super initWithFrame:CGRectMake(0.0, 65.0, [[UIScreen mainScreen] bounds].size.width, 185.0)])) {
		
		CGFloat fromLeft = 0.0;
		NSInteger index = 0;
		
		for (NSDate *date in daysParam) {
			
            CalendarWeekTile *tile = [[CalendarWeekTile alloc] initWithOrigin:CGPointMake(fromLeft, 0.0) day:date param:[params objectAtIndex:index]];
			[tile setDelegate:self];
			[self addSubview:tile];
			[tile release];
			
			fromLeft += 46.0;
			index++;
            
		}
	
    }
    return self;
}

- (void)dayDidClick:(NSDate *)dayClicked {
	[delegate dayDidClick:dayClicked];
}

- (void)dealloc {
    [super dealloc];
}

@end
