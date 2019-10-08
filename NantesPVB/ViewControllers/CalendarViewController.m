//
//  CalendarViewController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "CalendarViewController.h"
#import "TileParam.h"
#import "EventTableViewCell.h"
#import "EventDetailsViewController.h"

@implementation CalendarViewController

@synthesize dateLabel;
@synthesize dateFormatter;
@synthesize arrayOfEvents;
@synthesize dayEventsTableView;
@synthesize selectedEvents;
@synthesize monthView;
@synthesize contentView;

- (id)init {
    if (self = [super init]) {

        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        self.arrayOfEvents = [EventDao getEvents];
                
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Calendrier"];
        [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [[self navigationItem] setTitleView:titleLabel];
        [titleLabel release];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [[self view] addSubview:contentView];
        [contentView release];
        
        self.monthView = [[TKCalendarMonthView alloc] init];
        [monthView setDelegate:self];
        [monthView setDataSource:self];
        [contentView addSubview:monthView];
        [monthView release];
        
        self.dayEventsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, monthView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height-monthView.frame.size.height)];
        [dayEventsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[dayEventsTableView setDelegate:self];
		[dayEventsTableView setDataSource:self];
        [dayEventsTableView setEditing:NO animated:NO];
        [dayEventsTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
		[dayEventsTableView setBackgroundColor:[UIColor whiteColor]];
		[contentView addSubview:dayEventsTableView];
		[dayEventsTableView release];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.arrayOfEvents = [EventDao getEvents];
    [monthView reload];
    [dayEventsTableView reloadData];
}

- (void)calendarMonthView:(TKCalendarMonthView*)monthViewParam didSelectDate:(NSDate*)dateParam {
    
    self.selectedEvents = [EventDao getEventsForDate:dateParam];
    [dayEventsTableView reloadData];
    
}

- (void)calendarMonthView:(TKCalendarMonthView*)monthViewParam monthWillChange:(NSDate*)d {
    
}

- (void)calendarMonthView:(TKCalendarMonthView*)monthViewParam monthDidChange:(NSDate*)d {

}

- (void)calendarMonthViewDidResize:(TKCalendarMonthView*)monthViewParam {
    
    // Resize de la tableview suivant la hauteur du calendrier
    [dayEventsTableView setFrame:CGRectMake(0.0, monthViewParam.frame.origin.y+monthViewParam.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height-monthViewParam.frame.size.height-monthViewParam.frame.origin.y)];
    [dayEventsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
}

- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthViewParam marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate forMonth:(NSDate*)monthParam {
    
    self.arrayOfEvents = [EventDao getEventsFromDate:startDate];
    
    [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *dateFormatterEvent = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatterEvent setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
    [dateFormatterEvent setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    // Tableau de TileParam retourné en fin de fonction
	NSMutableArray *arrayOfTileParam = [NSMutableArray array];
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger numberOfDaysInMonth = [calendar components:NSDayCalendarUnit fromDate:startDate toDate:lastDate options:0].day;
	NSDateComponents *compToAdd = [[NSDateComponents alloc] init];
 
    // On boucle sur tous les jours du mois
    for (int i=0; i <= numberOfDaysInMonth; i++) {

		[compToAdd setDay:i];
		
		NSDate *currentDate = [calendar dateByAddingComponents:compToAdd toDate:startDate options:0];
		NSString *currentDay = [dateFormatter stringFromDate:currentDate];
        
		NSMutableArray *tmpArrayOfLine = nil;
		NSInteger childIndex = 0;

        for (Event *event in arrayOfEvents) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithInt:(int)childIndex] forKey:@"index"];
            
            NSString *eventDate = [dateFormatterEvent stringFromDate:[event date]];
            
            //NSLog(@"current: %@ | %@ : event", currentDay, [eventDate substringToIndex:10]);
   
            if ([currentDay isEqualToString:[eventDate substringToIndex:10]]) {
                
                if (tmpArrayOfLine == nil) {
                    tmpArrayOfLine = [[NSMutableArray alloc] init];
                }
                
                // Si l'event correspond avec le jours courant
                if ([event color] != nil) {
                    [dict setObject:[event color] forKey:@"color"];
                }else {
                    [dict setObject:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0] forKey:@"color"]; // TODO: voir pourquoi il n'y a pas de couleur sur ASSO par ex
                }
                
                [dict setObject:@"plain" forKey:@"type"]; // ou dash:   [dict setObject:@"dash" forKey:@"type"];
                
                [tmpArrayOfLine addObject:dict];
                [dict release];
                
                //NSLog(@"dict: %@", dict);
                
            }

            childIndex++;
            
        }

        TileParam *tileParam = [[TileParam alloc] initWithBackColor:nil
                                                        arrayOfLine:tmpArrayOfLine];
        [tileParam setDay:currentDay];
        [arrayOfTileParam addObject:tileParam];
        
        if (tmpArrayOfLine != nil) {
            [tmpArrayOfLine release];
        }
        
        [tileParam release];
        
    }
    
    return arrayOfTileParam;
    
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [selectedEvents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    EventTableViewCell *cell = (EventTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell loadEvent:[selectedEvents objectAtIndex:indexPath.row]];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    // On vérifie que c'est un membre: il s'est déjà connecté
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] length] > 0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"] length] > 0) {
  
        EventDetailsViewController *viewController = [[EventDetailsViewController alloc] initWithEvent:[selectedEvents objectAtIndex:indexPath.row]];
        [[self navigationController]pushViewController:viewController animated:YES];
        [viewController release];

    }

}

#pragma mark - Memory

- (void)dealloc {
    [dateLabel release];
    [dateFormatter release];
    [arrayOfEvents release];
    [dayEventsTableView release];
    [selectedEvents release];
    [monthView release];
    [contentView release];
    [super dealloc];
}

@end

