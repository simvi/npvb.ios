//
//  MembersTableViewCell.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "MembersTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MembersTableViewCell

@synthesize photoImageView;
@synthesize nameLabel;
@synthesize teamLabel;
@synthesize phoneLabel;
@synthesize grayView;
@synthesize isFirst;
@synthesize isLast;
@synthesize accessoryImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [[self contentView] setBackgroundColor:[UIColor whiteColor]];
        
        self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 4.0, self.contentView.frame.size.width, self.contentView.frame.size.height-8.0)];
        [grayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [grayView setBackgroundColor:kColorBgGray];
        [[self contentView] addSubview:grayView];
        [grayView release];
        
        UIView *circleWhiteView = [[UIView alloc] initWithFrame:CGRectMake(14.0, 7.0, 66.0, 66.0)];
        [circleWhiteView setBackgroundColor:kColorBgWhite];
        [[circleWhiteView layer] setCornerRadius:33.0];
        [[self contentView] addSubview:circleWhiteView];
        [circleWhiteView release];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 3.0, circleWhiteView.frame.size.width-6.0, circleWhiteView.frame.size.height-6.0)];
        [photoImageView setContentMode:(UIViewContentModeScaleAspectFill)];
        [photoImageView.layer setCornerRadius:(circleWhiteView.frame.size.width/2.0-3.0)];
        [photoImageView setClipsToBounds:YES];
        [circleWhiteView addSubview:photoImageView];
        [photoImageView release];
        
        // Nom et prenom
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 0.0, grayView.frame.size.width-100.0, grayView.frame.size.height)];
        [nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:kColorTitleGray];
        [nameLabel setFont:[UIFont systemFontOfSize:15.0]];
        [grayView addSubview:nameLabel];
        [nameLabel release];
        
        self.accessoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(grayView.frame.size.width-30.0, (grayView.frame.size.height-20.0)/2.0, 20.0, 20.0)];
        [accessoryImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [accessoryImageView setImageName:@"accessory.png"];
        [grayView addSubview:accessoryImageView];
        [accessoryImageView release];
        
	}
    return self;
}

- (void)loadMember:(Member*)memberParam {
    
    // On vérifie que c'est un membre: il s'est déjà connecté
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] length] > 0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"] length] > 0) {
    
        [accessoryImageView setAlpha:1.0];
        [photoImageView setImageWithURL:[NSURL URLWithString:[memberParam urlPhoto]] placeholderImage:[UIImage imageWithName:@"personne.png"]];
        [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [memberParam prenom], [memberParam nom]]];

    }
    else {

        [accessoryImageView setAlpha:0.0];
        [photoImageView setImage:[UIImage imageWithName:@"personne.png"]];
        [nameLabel setText:[NSString stringWithFormat:@"%@", [memberParam prenom]]];

    }
    
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    if (isFirst) {
        [self.grayView setFrame:CGRectMake(0.0, 0.0, self.contentView.frame.size.width, self.contentView.frame.size.height-4.0)];
    }
    else  if (isLast) {
        [self.grayView setFrame:CGRectMake(0.0, 4.0, self.contentView.frame.size.width, self.contentView.frame.size.height-4.0)];
    }
    else {
        [self.grayView setFrame:CGRectMake(0.0, 4.0, self.contentView.frame.size.width, self.contentView.frame.size.height-8.0)];
    }
    
}

- (void)dealloc {
    [photoImageView release];
    [nameLabel release];
    [teamLabel release];
    [phoneLabel release];
    [grayView release];
    [accessoryImageView release];
    [super dealloc];
}


@end
