//
//  CalendarWeekTile.m
//  MaNounou
//
//  Created by Michalak on 02/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarWeekTile.h"
#import "QueriesLibrary.h"
//#import "Constants.h"

#define dateFontSize 12.0

@implementation CalendarWeekTile

@synthesize day;
@synthesize back;
@synthesize weekParam;
@synthesize delegate;

- (id)initWithOrigin:(CGPoint)position day:(NSDate*)dayParam param:(WeekTileParam*)weekParamParam {

	CGRect frame = CGRectMake(position.x, position.y, 46.0, 185.0);
  
    if ((self = [super initWithFrame:frame])) {
		
		self.day = dayParam;
		self.weekParam = weekParamParam;
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *compoment = [calendar components:NSWeekdayCalendarUnit fromDate:day];
		[calendar release];
		
		self.back = @"blue";
		
        if ([compoment weekday] == 1 || [compoment weekday] == 7) {
			back = @"gray";
		}
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
	
	// Background & Jour
	UIImage *tile = [[UIImage imageNamed:[NSString stringWithFormat:@"date_Tile_%@.png",back]] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
	[imageView setImage:tile];
	[self addSubview:imageView];
	[imageView release];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
	
	UIFont *font;
	
    //UIColor *color = nil;
	
	if ([[dateFormatter stringFromDate:day] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
		font = [UIFont boldSystemFontOfSize:12];
	}else {
		font = [UIFont systemFontOfSize:11];
	}
	
    // Ligne du matin
	UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 28.0, self.frame.size.width, 1.0)];
	[view1 setBackgroundColor:[UIColor lightGrayColor]];
	[self addSubview:view1];
	[view1 release];
	
	// Ligne du midi
	UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 105.0, self.frame.size.width, 1.0)];
	[view2 setBackgroundColor:[UIColor lightGrayColor]];
	[self addSubview:view2];
	[view2 release];
	
}

- (UIImage*)getLine {
	
	//CGFloat fromTop = self.frame.origin.y + 23.0;
    
	UIImage *image = nil;

	UIGraphicsBeginImageContext(self.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();	
	CGContextBeginPath(context);  
	/*
	if ([[weekParam lineType] isEqualToString:@"dash"]) {
		float dash[2] = {5,10};
		CGContextSetLineDash(context, 0, dash, 2);
	}else {
		float dash[2] = {1,1};
		CGContextSetLineDash(context, 0, dash, 2);
	}

	// Child Line
	CGContextSetLineWidth(context, 4);
	CGContextSetStrokeColorWithColor(context, [[weekParam childColor] CGColor]);
	CGContextMoveToPoint(context, 1.0, fromTop); 
	CGContextAddLineToPoint(context, self.frame.size.width, fromTop);	
	CGContextClosePath(context);  	
	CGContextStrokePath(context);*/
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[delegate dayDidClick:day];
}

- (void)dealloc {
	[day release];
	[weekParam release];
	[back release];
    [super dealloc];
}

@end
