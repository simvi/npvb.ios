//
//  EtirementsViewController.m
//  Nantes PVB
//
//  Created by Marc Lievremont on 07/01/14.
//  Copyright (c) 2014 Personnal. All rights reserved.
//

#import "EtirementsViewController.h"

@implementation EtirementsViewController

- (id)init {

    if (self = [super init]) {
        
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Etirements"];
        [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [[self navigationItem] setTitleView:titleLabel];
        [titleLabel release];
        
        //btn retour
        UIImage *returnImage = [UIImage imageNamed:@"btn_return.png"];
        UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, returnImage.size.width, returnImage.size.height)];
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, returnImage.size.width, returnImage.size.height)];
        [returnButton setImage:returnImage forState:UIControlStateNormal];
        [returnButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [returnView addSubview:returnButton];
        [returnButton release];
        
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnView];
        self.navigationItem.leftBarButtonItem = returnButtonItem;
        [returnButtonItem release];
        [returnView release];
        
        //
        UIImage *etirImage = [UIImage imageNamed:@"etirements.png"];
        UIImageView *etirementsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-etirImage.size.width)/2.0, (self.view.frame.size.height-etirImage.size.height)/2.0, etirImage.size.width, etirImage.size.height)];
        [etirementsImageView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin)];
        [etirementsImageView setImage:etirImage];
        [[self view] addSubview:etirementsImageView];
        [etirementsImageView release];
        
    }
    return self;
}


#pragma mark - Buttons

- (void)backAction {
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    
    [super dealloc];
}

@end

