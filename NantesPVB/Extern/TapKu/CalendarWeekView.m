//
//  CalendarWeekView.m
//  MaNounou
//
//  Created by Michalak on 02/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CalendarWeekView.h"

#define kSun NSLocalizedString(@"dim.",@"")
#define kMon NSLocalizedString(@"lun.",@"")
#define kTue NSLocalizedString(@"mar.",@"")
#define kWed NSLocalizedString(@"mer.",@"")
#define kThu NSLocalizedString(@"jeu.",@"")
#define kFri NSLocalizedString(@"ven.",@"")
#define kSat NSLocalizedString(@"sam.",@"")

#define kPreviousBtnTag 1
#define kNextBtnTag 2
#define kCalendarTilesOldView 3
#define kCalendarTilesView 4

@implementation CalendarWeekView

@synthesize weekLabel;
@synthesize weekTypeLabel;
@synthesize currentDate;
@synthesize calendar;
@synthesize delegate;

- (id)initWithOrigin:(CGPoint)position {
  
    if ((self = [super initWithFrame:CGRectMake(position.x, position.y, [[UIScreen mainScreen] bounds].size.width, 250.0)])) {

		[self setBackgroundColor:[UIColor clearColor]];
        
		self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *component = [calendar components:(NSYearCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
		NSDateComponents *componentToAdd = [[NSDateComponents alloc] init];
		
		NSInteger diff = [component weekday] - 5;		
		if (diff < 0) {
			[componentToAdd setDay:-diff];	
		}else {
			[componentToAdd setDay:diff];	
		}

		NSDate *tmpCurrentDate = [calendar dateByAddingComponents:componentToAdd toDate:[NSDate date] options:0];
		NSDateComponents *currentComponent = [calendar components:(NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit) fromDate:tmpCurrentDate];
		self.currentDate = [calendar dateFromComponents:currentComponent];
		
		[componentToAdd release];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
	for (UIView *subview in [self subviews]) {
		[subview removeFromSuperview];
	}
	
	// Semaine / Navigation / Jours
	UIButton *leftArrow = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 38.0)];
	[leftArrow setTag:kPreviousBtnTag];
	[leftArrow addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
	[leftArrow setImage:[UIImage imageWithName:@"left_arrow.png"] forState:(UIControlStateNormal)];
	[self addSubview:leftArrow];
	[leftArrow release];
	
	self.weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.0, 0.0, 224.0, 38.0)];
	[weekLabel setTextAlignment:NSTextAlignmentCenter];
	[weekLabel setTextColor:[UIColor colorWithRed:(59.0/255.0) green:(73.0/255.0) blue:(88.0/255.0) alpha:1.0]];
	[weekLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[weekLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:weekLabel];
	[weekLabel release];
	
	[self updateTitle];
	
	self.weekTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(48.0, 30.0, 224.0, 15.0)];
	[weekTypeLabel setTextAlignment:NSTextAlignmentCenter];
	[weekTypeLabel setTextColor:[UIColor colorWithRed:(59.0/255.0) green:(73.0/255.0) blue:(88.0/255.0) alpha:1.0]];
	[weekTypeLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[weekTypeLabel setBackgroundColor:[UIColor clearColor]];
	[self addSubview:weekTypeLabel];
	[weekTypeLabel release];
	
	UIButton *rightArrow = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-45.0, 0.0, 48.0, 38.0)];
	[rightArrow setTag:kNextBtnTag];
	[rightArrow addTarget:self action:@selector(changeWeek:) forControlEvents:UIControlEventTouchUpInside];
	[rightArrow setImage:[UIImage imageWithName:@"right_arrow.png"] forState:0];
	[self addSubview:rightArrow];
	[rightArrow release];
	
    // Jours de la semaine
	NSArray *arrayOfDay = [NSArray arrayWithObjects:kMon,kTue,kWed,kThu,kFri,kSat,kSun,nil];
	int i = 0;
	for (NSString *day in arrayOfDay) {
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(46 * i, 45.0, 46.0, 15.0)];
		[label setText:day];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setFont:[UIFont systemFontOfSize:11]];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setTextColor:[UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1]];
		[self addSubview:label];
		[label release];

		i++;
	}
	// --
	
	// Weeks view
	NSArray *days = [self getDaysOfWeek];
	NSArray *params = [delegate paramsForDays:days];
	
	CalendarWeekTiles *tiles = [[CalendarWeekTiles alloc] initWithDays:[self getDaysOfWeek] params:params];
	[tiles setDelegate:self];
	[tiles setTag:kCalendarTilesOldView];
	[self addSubview:tiles];
	[tiles release];
    
	// --
	
}

- (NSArray*)getDaysOfWeek {
	
	NSMutableArray *days = [NSMutableArray array];
	NSDateComponents *components = [[NSDateComponents alloc] init];
	NSDate *tmpDate = nil;
	NSInteger firstWeekDay = 2;
	NSInteger weekday = [[calendar components:NSWeekdayCalendarUnit fromDate:currentDate] weekday];
	NSInteger weekDayDiff = weekday - firstWeekDay;
	
	if (weekDayDiff < 0) {
		[components setDay:-6];
	}else {
		[components setDay:-weekDayDiff];	
	}
	
	// Ajout du lundi
	tmpDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
	[days addObject:tmpDate];
	[components setDay:1];
	
	// Ajout des autres jour
	for (int i= 1; i < 7; i++) {
		tmpDate = [calendar dateByAddingComponents:components toDate:tmpDate options:0];
		[days addObject:tmpDate];
	}
	
	return days;
}

- (void)changeWeek:(UIButton*)button {
	
	[self setUserInteractionEnabled:NO];
	
	if ([button tag] == kPreviousBtnTag) {		

		// Previous Week
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setWeek:-1];
		self.currentDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
		[dateComponents release];
		
		[self loadPreviousWeek];
		
	}else {
		// Next Week
		NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
		[dateComponents setWeek:1];
		self.currentDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];
		[dateComponents release];
		
		[self loadNextWeek];
	}
	
	[self updateTitle];
}

- (void)loadPreviousWeek {
	
	NSArray *days = [self getDaysOfWeek];
	NSArray *params = [delegate paramsForDays:days];
	
	CalendarWeekTiles *viewToAdd = [[CalendarWeekTiles alloc] initWithDays:days params:params];
	[viewToAdd setDelegate:self];
	[viewToAdd setFrame:CGRectMake(viewToAdd.frame.origin.x - viewToAdd.frame.size.width, viewToAdd.frame.origin.y, viewToAdd.frame.size.width, viewToAdd.frame.size.height)];
	[viewToAdd setTag:kCalendarTilesView];
	[self addSubview:viewToAdd];
	[viewToAdd release];
	
	// Animation Top to Bottom	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDuration:0.4];

	CalendarWeekTiles *viewToRemove = (CalendarWeekTiles*)[self viewWithTag:kCalendarTilesOldView];
	[viewToAdd setFrame:CGRectMake(viewToAdd.frame.origin.x + viewToAdd.frame.size.width, viewToAdd.frame.origin.y, viewToAdd.frame.size.width, viewToAdd.frame.size.height)];
	[viewToRemove setFrame:CGRectMake(viewToRemove.frame.origin.x + viewToRemove.frame.size.width, viewToRemove.frame.origin.y, viewToRemove.frame.size.width, viewToRemove.frame.size.height)];
	
	[UIView commitAnimations];
}

- (void)loadNextWeek {
	
	NSArray *days = [self getDaysOfWeek];
	NSArray *params = [delegate paramsForDays:days];
	
	CalendarWeekTiles *viewToAdd = [[CalendarWeekTiles alloc] initWithDays:days params:params];
	[viewToAdd setDelegate:self];
	[viewToAdd setFrame:CGRectMake(viewToAdd.frame.origin.x + viewToAdd.frame.size.width, viewToAdd.frame.origin.y, viewToAdd.frame.size.width, viewToAdd.frame.size.height)];
	[viewToAdd setTag:kCalendarTilesView];
	[self addSubview:viewToAdd];
	[viewToAdd release];
	
	if ([delegate respondsToSelector:@selector(weekWillChanged)]) {
		[delegate weekWillChanged];	
	}
	
	// Animation Bottom to Top
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDuration:0.4];
	
	CalendarWeekTiles *viewToRemove = (CalendarWeekTiles*)[self viewWithTag:kCalendarTilesOldView];
	[viewToAdd setFrame:CGRectMake(viewToAdd.frame.origin.x - viewToAdd.frame.size.width, viewToAdd.frame.origin.y, viewToAdd.frame.size.width, viewToAdd.frame.size.height)];
	[viewToRemove setFrame:CGRectMake(viewToRemove.frame.origin.x - viewToRemove.frame.size.width, viewToRemove.frame.origin.y, viewToRemove.frame.size.width, viewToRemove.frame.size.height)];
	
	[UIView commitAnimations];
}

- (void)animationEnded {

	[[self viewWithTag:kCalendarTilesOldView] removeFromSuperview];
	
	CalendarWeekTiles *calendarView = (CalendarWeekTiles*)[self viewWithTag:kCalendarTilesView];
	[calendarView setTag:kCalendarTilesOldView];
	
	[self setUserInteractionEnabled:YES];
	
	if ([delegate respondsToSelector:@selector(weekDidChanged)]) {
		[delegate weekDidChanged];	
	}
}

#pragma mark -
#pragma mark CalendarTilesView Delegate

- (void)dayDidClick:(NSDate *)dayClicked {
	[delegate calendarWeekView:self didClickDay:dayClicked];
}

#pragma mark -
#pragma mark Actions

- (void)updateTitle {
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"'Semaine' w (MMMM yyyy)"];
	NSString *label = [[dateFormatter stringFromDate:currentDate] capitalizedString];
	[weekLabel setText:label];
	[dateFormatter release];
	
}

- (void)reloadData {
	for (UIView *subview in [self subviews]) {
		for (UIView *subview2 in [subview subviews]) {
			[subview2 setNeedsDisplay];
		}
		[subview setNeedsDisplay];
	}
	[self setNeedsDisplay];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
	[calendar release];
	[weekLabel release];
	[weekTypeLabel release];
	[currentDate release];
    [super dealloc];
}


@end
