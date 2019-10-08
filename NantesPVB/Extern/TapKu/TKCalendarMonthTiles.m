//
//  TKCalendarMonthView.m
//  Created by Devin Ross on 6/9/10.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "TKCalendarMonthTiles.h"
#import "NSDate+TKCategory.h"
#import "TKGlobal.h"
#import "UIImage+TKCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "QueriesLibrary.h"
#import "TileParam.h"
#import <NantesPVB-Swift.h>

#define dotFontSize 18.0
#define dateFontSize 12.0
#define kShowDaySelector 1
#define kTileHeight 39.0

@interface TKCalendarMonthTiles (private)

@property (readonly) UIImageView *selectedImageView;
@property (readonly) UILabel *currentDay;
@property (readonly) UILabel *dot;
@end

@implementation TKCalendarMonthTiles
@synthesize monthDate;

+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)date startOnSunday:(BOOL)sunday{

	NSDate *firstDate, *lastDate;
	
	TKDateInformation info = [date dateInformation];
	info.day = 1;
	NSDate *d = [NSDate dateFromDateInformation:info];
	info = [d dateInformation];
	
	if((sunday && info.weekday>1) || (!sunday && info.weekday!=2)){
		
		TKDateInformation info2 = info;
		
		info2.month--;
		if(info2.month<1) { info2.month = 12; info2.year--; }
		NSDate *previousMonth = [NSDate dateFromDateInformation:info2];
		int preDayCnt = [previousMonth daysInMonth];		
		info2.day = preDayCnt - info.weekday;
		if (sunday) {
			info2.day += 2;
		} else {
			if (info.weekday == 1) {
				info2.day -= 4;
			} else {
				info2.day += 3;
			}
		}
		
		firstDate = [NSDate dateFromDateInformation:info2];
				
	}else{
		firstDate = d;
	}

	int daysInMonth = [d daysInMonth];
	info.day = daysInMonth;
	NSDate *lastInMonth = [NSDate dateFromDateInformation:info];
	info = [lastInMonth dateInformation];
	if((sunday && info.weekday < 7) || (!sunday && info.weekday != 1)){
		if (sunday) {
			info.day = 7 - info.weekday;
		}
		else {
			info.day = 7 - info.weekday + 1;
		}
		info.month++;
		if(info.month>12){
			info.month = 1;
			info.year++;
		}
		lastDate = [NSDate dateFromDateInformation:info];
	}else{
		lastDate = lastInMonth;
	}
	
	return [NSArray arrayWithObjects:firstDate,lastDate,nil];
}

- (id) initWithMonth:(NSDate*)date marks:(NSArray*)markArray startDayOnSunday:(BOOL)sunday{
	
    [self setBackgroundColor:[UIColor redColor]];
    
	firstOfPrev = -1;
	marks = [markArray retain];
	monthDate = [date retain];
	startOnSunday = sunday;
	
	TKDateInformation dateInfo = [monthDate dateInformation];
	firstWeekday = dateInfo.weekday;
	daysInMonth = [date daysInMonth]; 
	
	TKDateInformation todayInfo = [[NSDate date] dateInformation];
	today = dateInfo.month == todayInfo.month && dateInfo.year == todayInfo.year ? todayInfo.day : 0;
	
	if((sunday && firstWeekday>1) || (!sunday && firstWeekday!=2)){
		
        dateInfo.month--;
		if(dateInfo.month<1) {
			dateInfo.month = 12;
			dateInfo.year--;
		}
        
		NSDate *previousMonth = [NSDate dateFromDateInformation:dateInfo];
		int preDayCnt = [previousMonth daysInMonth];
		firstOfPrev = preDayCnt - firstWeekday;
		if (sunday) {
			firstOfPrev += 2;
		} else {
			if (firstWeekday == 1) {
				firstOfPrev -= 4;
			} else {
				firstOfPrev += 3;
			}
		}
		lastOfPrev = preDayCnt;
        
	}
	
	int prevDays = (firstOfPrev == -1 ? 0 : lastOfPrev - firstOfPrev + 1);
	int row = daysInMonth + prevDays;
	row = (row / 7) + ((row % 7 == 0) ? 0:1);
	
	float h = kTileHeight * row;
    
    /*
    CGFloat decalage = 1.0;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        decalage = -64.0;
    }
    */
	   
	if(![super initWithFrame:CGRectMake(0, 1.0, [[UIScreen mainScreen] bounds].size.width, h+1)]) {
        return nil;
    }
    
	[self.selectedImageView addSubview:self.currentDay];
	[self.selectedImageView addSubview:self.dot];
    
    //[self setFrame:CGRectMake(0.0, -64.0, 320, 150)];
    
	self.multipleTouchEnabled = NO;
	
	return self;
}

- (void) setTarget:(id)t action:(SEL)a{
	target = t;
	action = a;
}

- (CGRect) rectForCellAtIndex:(int)index {
    
    // Calcul de la largeur d'une case / tile
	
	int row = index / 7;
	int col = index % 7;
	
    CGFloat tileWidth = ceilf([(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width/7.0);
    
	return CGRectMake(col*tileWidth, row*kTileHeight, tileWidth, kTileHeight+1);
    
}

- (void) drawTileInRect:(CGRect)r day:(int)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2{
	
    // Numero jour du ois
	NSString *str = [NSString stringWithFormat:@"%d",day];
	
    //NSLog(@"str: %@", str);
    
	r.size.height -= 2;
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: UILineBreakModeWordWrap 
		  alignment: NSTextAlignmentCenter];
    
	/*
	if(mark){
		r.size.height = 10;
		r.origin.y += 18;
		
		[@"•" drawInRect: r
				withFont: f2
		   lineBreakMode: UILineBreakModeWordWrap 
			   alignment: NSTextAlignmentCenter];
	}
	 */
	
}

- (void) drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGRect r = CGRectMake(0, 0, ceilf([(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width/7.0), kTileHeight);
	
    // Cellule normal
	UIImage *tile = [UIImage imageNamed:@"date_Tile.png"];
	CGContextDrawTiledImage(context, r, tile.CGImage);
	// --
	
	if(today > 0){
		int pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		int index = today +  pre-1;
		CGRect r =[self rectForCellAtIndex:index];
		r.origin.y -= 7;
		//[[UIImage imageNamed:@"today_Tile.png"] drawInRect:r];
	}
	
	int index = 0;
	
	UIFont *font = [UIFont systemFontOfSize:dateFontSize];
	UIFont *font2 =[UIFont boldSystemFontOfSize:dotFontSize];
	
	UIColor *color = [UIColor lightGrayColor];
	UIColor *color2 = [UIColor darkGrayColor];
    
	// Cellule du mois précédent
	if(firstOfPrev>0){
	
        [color set];
        
		for(int i = firstOfPrev;i<= lastOfPrev;i++){
			
			r = [self rectForCellAtIndex:index] ;
			
			// Cellule particuliere
			if ([marks count] > index) {
				
				CGRect backRect = CGRectMake(r.origin.x, r.origin.y, r.size.width - 1.0, r.size.height - 1.0);
				                
				// Modification sur la cellule
				UIImage *linesImage = [self getLinesFor:[(TileParam*)[marks objectAtIndex:index] arrayOfLine] inRect:backRect];
				[linesImage drawInRect:backRect];

            }
        
			[self drawTileInRect:CGRectMake(r.origin.x + (r.size.width / 2)-10.0, r.origin.y+6, (r.size.width / 2), (r.size.height / 2)) day:i mark:NO font:font font2:font2];
			
            index++;
            
		}
	}
	// --
	
	// Cellule du mois courant
	for(int i=1; i <= daysInMonth; i++){
		
		r = [self rectForCellAtIndex:index];
        
		if(today == i) {
            // Font de la date d'aujourdhui
			font = [UIFont boldSystemFontOfSize:14];
		}else {
			font = [UIFont systemFontOfSize:dateFontSize];
		}
		
		CGRect backRect = CGRectMake(r.origin.x, r.origin.y, r.size.width - 1.0, r.size.height - 1.0);
		NSString *back = @"blue";
		
		NSDateComponents *component = [[NSDateComponents alloc] init];
		[component setDay:(i - 1)];
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [calendar dateByAddingComponents:component toDate:monthDate options:0];
		//NSInteger weekday = [[calendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:currentDate] weekday];
		[calendar release];
		[component release];
		
        
		UIImage *tile = [UIImage imageNamed:[NSString stringWithFormat:@"date_Tile_%@.png",back]];
		[tile drawInRect:backRect];
		
        ///
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        
        if ([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
            [color2 set];
		}
        else {
            [color set];
        }
        
		// Cellule particuliere
		if ([marks count] > index) {
			
			CGRect backRect = CGRectMake(r.origin.x, r.origin.y, r.size.width - 1.0, r.size.height - 1.0);
			
			// Modification sur la cellule
			UIImage *tile = [UIImage imageNamed:[NSString stringWithFormat:@"date_Tile_%@.png",back]];
			[tile drawInRect:backRect];
			
            NSLog(@"currentDate: %@  -- %i events", currentDate, (int)[[[marks objectAtIndex:index] arrayOfLine] count]);

			UIImage *linesImage = [self getLinesFor:[[marks objectAtIndex:index] arrayOfLine] inRect:backRect];
			[linesImage drawInRect:backRect];
            
        }
	
		[self drawTileInRect:CGRectMake(r.origin.x + (r.size.width / 2)-12.0, r.origin.y+6.0, (r.size.width / 2), (r.size.height / 2)) day:i mark:NO font:font font2:font2];
        
		index++;
        
	}
	
	// Cellule du mois suivant
	[[UIColor lightGrayColor] set];
    
	int i = 1;

    while(index % 7 != 0) {
        
		r = [self rectForCellAtIndex:index] ;
		
		// Cellule particuliere
		if ([marks count] > index) {
			
			CGRect backRect = CGRectMake(r.origin.x, r.origin.y, r.size.width - 1.0, r.size.height - 1.0);
			
			// Modification sur la cellule
			UIImage *linesImage = [self getLinesFor:[[marks objectAtIndex:index] arrayOfLine] inRect:backRect];
			[linesImage drawInRect:backRect];
			// --
            
		}
        
		// -- 
		
		[self drawTileInRect:CGRectMake(r.origin.x + (r.size.width / 2)-11.0, r.origin.y+6.0, (r.size.width / 2), (r.size.height / 2)) day:i mark:NO font:font font2:font2];
		i++;
		index++;
        
	}
    
	// --
    
}

- (UIImage*)getLinesFor:(NSArray*)array inRect:(CGRect)backRect {

    ///
    // Ligne des evenement en bas des tiles (image qui est ensuite ajouté a la tile)
    ///
    
    CGFloat lineWidth = 3.0;
	CGFloat fromTop = backRect.size.height - (lineWidth / 2) - 1;
	UIImage *linesImage;
	UIGraphicsBeginImageContext(CGSizeMake(backRect.size.width, backRect.size.height));
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, lineWidth);
    int cpt = 0.0;
	for (NSDictionary *dict in array) {
        
		//fromTop -= ([(NSNumber*)[dict objectForKey:@"index"] floatValue] * (CGFloat)(2 + lineWidth));
		fromTop -= (cpt * (CGFloat)(2 + lineWidth));
        
		CGContextBeginPath(context);
		
        /*
		if ([dict objectForKey:@"type"] == nil) {
			CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);			
		}else if ([[dict objectForKey:@"type"] isEqualToString:@"dash"]) {
			float dash[2] = {5,10};
			CGContextSetLineDash(context, 0, dash, 2);
			CGContextSetStrokeColorWithColor(context, [(UIColor*)[dict objectForKey:@"color"] CGColor]);
		}else if ([[dict objectForKey:@"type"] isEqualToString:@"plain"]) {
			float dash[2] = {1,1};
			CGContextSetLineDash(context, 0, dash, 2);
			CGContextSetStrokeColorWithColor(context, [(UIColor*)[dict objectForKey:@"color"] CGColor]);
		}
         */
        
        CGContextSetStrokeColorWithColor(context, [(UIColor*)[dict objectForKey:@"color"] CGColor]);
    			
		CGContextMoveToPoint(context, 1.0, fromTop); 
		CGContextAddLineToPoint(context, backRect.size.width, fromTop);  
		CGContextClosePath(context);  	
		CGContextStrokePath(context);
        
		fromTop = backRect.size.height - (lineWidth / 2) - 1;
		cpt++;
        
	}

  
	linesImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return linesImage;
    
}
 
- (void) selectDay:(int)day {
	
	int pre = firstOfPrev < 0 ?  0 : lastOfPrev - firstOfPrev + 1;
	
	int tot = day + pre;
	int row = tot / 7;
	int column = (tot % 7)-1;
	
	selectedDay = day;
	selectedPortion = 1;

	if(day == today){
		
        self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
        
        // Image de selection du jour courant
		self.selectedImageView.image = [UIImage imageNamed:@"today_Selected_Tile.png"];
		markWasOnToday = YES;
        
	}else if(markWasOnToday){
	
        self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		
        // Image de selection d'un jour de la semaine
        self.selectedImageView.image = [UIImage imageNamed:@"date_Tile_Selected.png"];
		markWasOnToday = NO;
        
	}
	
	[self addSubview:self.selectedImageView];
    
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
    /*
    NSLog(@"mark: %@", [[marks objectAtIndex: row * 7 + column] class]);
    
	if([[marks objectAtIndex: row * 7 + column] boolValue]){
		[self.selectedImageView addSubview:self.dot];
	}else{
		[self.dot removeFromSuperview];
	}
	*/
    
	if(column < 0){
		column = 6;
		row--;
	}
    
    CGFloat tileWidth = ceilf([(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width/7.0);
    
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*tileWidth);
    r.origin.y = (row*kTileHeight)-8;
    r.size.width = tileWidth;
	self.selectedImageView.frame = r;
	
	if (!kShowDaySelector) {
		[selectedImageView setHidden:YES];
	}
	
}

- (NSDate*) dateSelected{
	
    if(selectedDay < 1 || selectedPortion != 1) return nil;
	
	TKDateInformation info = [monthDate dateInformation];
	info.day = selectedDay;
	
    return [NSDate dateFromDateInformation:info];
    
}

- (void) reactToTouch:(UITouch*)touch down:(BOOL)down{
		
    // Selection d'un tile
    
    CGFloat tileWidth = ceilf([(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width/7.0);

	CGPoint p = [touch locationInView:self];
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	int column = p.x / tileWidth, row = p.y / kTileHeight;
	int day = 1, portion = 0;
	
	if(row == (int) (self.bounds.size.height / kTileHeight)) row --;
	
	if (startOnSunday) {
		if(row==0 && column < firstWeekday-1){
			day = firstOfPrev + column;
		} else {
			portion = 1;
			day = row * 7 + column  - firstWeekday+2;
		}
	}
	else {
		
        if(row==0 && column < firstWeekday-2){
			day = firstOfPrev + column;
		} else {
			portion = 1;
			if (firstWeekday == 1) {
				day = row * 7 + column  - firstWeekday - 4;
			}
			else {
				day = row * 7 + column  - firstWeekday + 3;
			}
		}
        
	}
	
    if(portion > 0 && day > daysInMonth){
		portion = 2;
		day = day - daysInMonth;
	}	
	
	if(portion != 1){
		
        self.selectedImageView.image = [UIImage imageNamed:@"date_Tile_Gray.png"];
		markWasOnToday = YES;
        
	}else if(portion==1 && day == today){
		
        self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageNamed:@"today_Selected_Tile.png"];
		markWasOnToday = YES;
        
	}else if(markWasOnToday){
		
        self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageNamed:@"date_Tile_Selected.png"];
		markWasOnToday = NO;
        
	}
	
	[self addSubview:self.selectedImageView];

	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
	/*
	if([[marks objectAtIndex: row * 7 + column] boolValue])
		[self.selectedImageView addSubview:self.dot];
	else
		[self.dot removeFromSuperview];
	*/
	
    // Changement de mois, on resize les bulles
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*tileWidth);
	r.origin.y = (row*kTileHeight)-8;
    r.size.width = tileWidth;

	self.selectedImageView.frame = r;

	if(day == selectedDay && selectedPortion == portion) return;
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
		[target performSelector:action withObject:[NSArray arrayWithObject:[NSNumber numberWithInt:day]]];

	}
	else if(down){
		[target performSelector:action withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:day],[NSNumber numberWithInt:portion],nil]];
		selectedDay = day;
		selectedPortion = portion;
	}
	
	if (!kShowDaySelector) {
		[selectedImageView setHidden:YES];
	}

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//[super touchesBegan:touches withEvent:event];
	//[self reactToTouch:[touches anyObject] down:NO];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//[self reactToTouch:[touches anyObject] down:NO];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:YES];
}

- (UILabel *)currentDay {
	
    if(currentDay==nil){

        CGFloat tileWidth = ceilf([(AppDelegate*)[[UIApplication sharedApplication] delegate] window].rootViewController.view.frame.size.width/7.0);

		CGRect r = CGRectMake(0.0, 0.0, tileWidth, selectedImageView.frame.size.height-2.0);
		currentDay = [[UILabel alloc] initWithFrame:r];
		currentDay.text = @"1";
		currentDay.textColor = [UIColor whiteColor];
		currentDay.backgroundColor = [UIColor clearColor]; // label current day number
		currentDay.font = [UIFont boldSystemFontOfSize:dateFontSize];
		currentDay.textAlignment = NSTextAlignmentCenter;
		//currentDay.shadowColor = [UIColor darkGrayColor];
		//currentDay.shadowOffset = CGSizeMake(0, -1);
        
	}
	
    return currentDay; //Numero affiché quand on selectionne une cellule

}

- (UILabel *)dot {
	
    if(dot==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y += 29;
		r.size.height -= 31;
		dot = [[UILabel alloc] initWithFrame:r];
		
		dot.text = @"•";
		dot.textColor = [UIColor whiteColor];
		dot.backgroundColor = [UIColor clearColor];
		dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
		dot.textAlignment = NSTextAlignmentCenter;
		dot.shadowColor = [UIColor darkGrayColor];
		dot.shadowOffset = CGSizeMake(0, -1);
	}
	
    //return dot; // Point en bas quand on selectionne une cellule
    
	return nil;
    
}

- (UIImageView *) selectedImageView {
	
    if(selectedImageView==nil){
		selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"date_Tile_Selected.png"]];
        [selectedImageView setContentMode:(UIViewContentModeScaleAspectFill)];
	}

	return selectedImageView;
    
}

//- (UITraitCollection *)traitCollection {
//    return UITraitCollection.currentTraitCollection;
//}

- (void)dealloc {
	[currentDay release];
	[dot release];
	[selectedImageView release];
	[marks release];
	[monthDate release];
    [super dealloc];
}


@end
