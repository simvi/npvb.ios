//
//  CalendarWeekView.h
//  MaNounou
//
//  Created by Michalak on 02/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarWeekTiles.h"

@protocol CalendarWeekViewDelegate;

@interface CalendarWeekView : UIView <CalendarWeekTilesDelegate> {
	
	UILabel							*weekLabel;
	UILabel							*weekTypeLabel;
	NSDate							*currentDate;
	NSCalendar						*calendar;
	id<CalendarWeekViewDelegate>	delegate;
}

@property (nonatomic, retain) UILabel						*weekLabel;
@property (nonatomic, retain) UILabel						*weekTypeLabel;
@property (nonatomic, retain) NSDate						*currentDate;
@property (nonatomic, retain) NSCalendar					*calendar; 
@property (nonatomic, assign) id<CalendarWeekViewDelegate>	delegate;

- (id)initWithOrigin:(CGPoint)position;
- (NSArray*)getDaysOfWeek;
- (void)updateTitle;
- (void)loadPreviousWeek;
- (void)loadNextWeek;
- (void)reloadData;

@end

@protocol CalendarWeekViewDelegate <NSObject>

@required
- (void)calendarWeekView:(CalendarWeekView*)calendar didClickDay:(NSDate*)dayClicked;
- (NSArray*)paramsForDays:(NSArray*)days;
@optional
- (void)weekWillChanged;
- (void)weekDidChanged;

@end
