//
//  CalendarViewController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDao.h"
#import "TKCalendarMonthView.h"

@interface CalendarViewController : UIViewController <TKCalendarMonthViewDelegate, TKCalendarMonthViewDataSource, UITableViewDataSource, UITableViewDelegate> {
    
    UILabel             *dateLabel;
    NSDateFormatter     *dateFormatter;
    NSMutableArray      *arrayOfEvents;
    NSMutableArray      *selectedEvents;
    UITableView         *dayEventsTableView;
    TKCalendarMonthView *monthView;
    UIView              *contentView;
}

@property(nonatomic, retain) UILabel                *dateLabel;
@property(nonatomic, retain) NSDateFormatter        *dateFormatter;
@property(nonatomic, retain) NSMutableArray         *arrayOfEvents;
@property(nonatomic, retain) UITableView            *dayEventsTableView;
@property(nonatomic, retain) NSMutableArray         *selectedEvents;
@property(nonatomic, retain) TKCalendarMonthView    *monthView;
@property(nonatomic, retain) UIView                 *contentView;

@end
