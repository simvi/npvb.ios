//
//  CalendarWeekTile.h
//  MaNounou
//
//  Created by Michalak on 02/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekTileParam.h"
#import "Event.h"
//#import "Child.h"

@protocol CalendarWeekTileDelegate;

@interface CalendarWeekTile : UIView {
	NSDate							*day;
	NSString						*back;
	WeekTileParam					*weekParam;
	id<CalendarWeekTileDelegate>	delegate;
}

@property (nonatomic, retain) NSDate						*day; 
@property (nonatomic, retain) NSString						*back;
@property (nonatomic, retain) WeekTileParam					*weekParam;
@property (nonatomic, assign) id<CalendarWeekTileDelegate>	delegate;

- (id)initWithOrigin:(CGPoint)position day:(NSDate*)dayParam param:(WeekTileParam*)weekParamParam;
- (UIImage*)getLine;

@end

@protocol CalendarWeekTileDelegate <NSObject>

@required
- (void)dayDidClick:(NSDate *)dayClicked;

@end
