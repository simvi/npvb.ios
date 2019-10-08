//
//  OtherTableViewCell.m
//  Nantes PVB
//
//  Created by Damien Traille on 13/11/2013.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import "OtherTableViewCell.h"

@implementation OtherTableViewCell

@synthesize nameLabel;
@synthesize grayView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 4.0, self.contentView.frame.size.width, self.contentView.frame.size.height-8.0)];
        [grayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [grayView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        [[self contentView] addSubview:grayView];
        [grayView release];
        
        // Nom et prenom
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, grayView.frame.size.width-50.0, grayView.frame.size.height)];
        [nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [grayView addSubview:nameLabel];
        [nameLabel release];
        
        UIImageView *accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(grayView.frame.size.width-30.0, (grayView.frame.size.height-20.0)/2.0, 20.0, 20.0)];
        [accessoryImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [accessoryImageView setImageName:@"accessory.png"];
        [grayView addSubview:accessoryImageView];
        [accessoryImageView release];
        
	}
    return self;
}

- (void)loadCell:(NSString*)titleParam {

    [nameLabel setText:[NSString stringWithFormat:@"%@", titleParam]];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self.grayView setFrame:CGRectMake(0.0, 8.0, self.contentView.frame.size.width, self.contentView.frame.size.height-8.0)];
    
}

- (void)dealloc {
    [nameLabel release];
    [grayView release];
    [super dealloc];
}


@end
