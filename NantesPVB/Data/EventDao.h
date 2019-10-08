//
//  EventDao.h
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueriesLibrary.h"
#import "Event.h"

@interface EventDao : NSObject

+ (void)insertEvents:(NSMutableArray*)arrayParam;
+ (NSMutableArray*)getEvents;
+ (NSMutableArray*)getEventsFromDate:(NSDate*)dateParam;
+ (NSMutableArray*)getEventsForDate:(NSDate*)dateParam;

@end
