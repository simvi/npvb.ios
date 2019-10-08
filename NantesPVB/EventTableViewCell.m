//
//  EventTableViewCell.m
//  Nantes PVB
//
//  Created by Damien Traille on 11/09/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize titleLabel;
@synthesize accessoryImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [[self contentView] setBackgroundColor:[UIColor whiteColor]];
    
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, self.frame.size.width-20.0, self.frame.size.height)];
        [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
		[titleLabel setNumberOfLines:0];
        [titleLabel setFont:[UIFont systemFontOfSize:13.0]];
		[[self contentView] addSubview:titleLabel];
		[titleLabel release];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.frame.size.height-1.0, self.contentView.frame.size.width, 1.0)];
        [grayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [grayView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        [[self contentView] addSubview:grayView];
        [grayView release];

        self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-30.0, (self.contentView.frame.size.height-20.0)/2.0, 20.0, 20.0)];
        [accessoryImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [accessoryImageView setImageName:@"accessory.png"];
        [[self contentView] addSubview:accessoryImageView];
        [accessoryImageView release];
        
	}
    return self;
}

- (void) loadEvent:(Event*)eventParam {

    NSMutableString *eventString = [NSMutableString stringWithFormat:@"%@ - %@", [eventParam titre], [eventParam intitule]];
    [eventString replaceOccurrencesOfString:@"Ã©" withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [eventString length])];
    [eventString replaceOccurrencesOfString:@"Ã¨" withString:@"è" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [eventString length])];
    [eventString replaceOccurrencesOfString:@"Ã«" withString:@"ë" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [eventString length])];
    [eventString replaceOccurrencesOfString:@"Ã" withString:@"à" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [eventString length])];

    //NSLog(@"eventString: %@", eventString);
    
    [titleLabel setText:eventString];
    
    // On vérifie que c'est un membre: il s'est déjà connecté
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] length] > 0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"] length] > 0) {
        [accessoryImageView setAlpha:1.0];
    }
    else {
        [accessoryImageView setAlpha:0.0];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    [titleLabel setFrame:CGRectMake(10.0, 0.0, self.frame.size.width-20.0, self.frame.size.height)];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    
}

- (void)dealloc {
    
    [titleLabel release];
    [accessoryImageView release];
    [super dealloc];
}


@end
