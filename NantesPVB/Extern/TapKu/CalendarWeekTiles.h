//
//  CalendarWeekTiles.h
//  MaNounou
//
//  Created by Michalak on 03/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarWeekTile.h"

@protocol CalendarWeekTilesDelegate;

@interface CalendarWeekTiles : UIView <CalendarWeekTileDelegate> {
	id<CalendarWeekTilesDelegate>		delegate;
}

@property (nonatomic, assign) id<CalendarWeekTilesDelegate>		delegate;

- (id)initWithDays:(NSArray*)daysParam params:(NSArray*)params;

@end

@protocol CalendarWeekTilesDelegate <NSObject>

@required
- (void)dayDidClick:(NSDate *)dayClicked;

@end