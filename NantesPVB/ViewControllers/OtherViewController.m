//
//  OtherViewController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "OtherViewController.h"
#import "OtherTableViewCell.h"
#import "QuestionsReponsesViewController.h"
#import "EtirementsViewController.h"

@implementation OtherViewController

@synthesize othersTableView;

- (id)init {
    if (self = [super init]) {
        
        nbLines = 2;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Autres"];
        [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [[self navigationItem] setTitleView:titleLabel];
        [titleLabel release];
        
        self.othersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [othersTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
		[othersTableView setDelegate:self];
		[othersTableView setDataSource:self];
        [othersTableView setEditing:NO animated:NO];
		[othersTableView setBackgroundColor:[UIColor whiteColor]];
		[othersTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
		[[self view] addSubview:othersTableView];
		[othersTableView release];
        
    }
    return self;
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return nbLines;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    OtherTableViewCell *cell = (OtherTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[OtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:(UITableViewCellAccessoryNone)];
    }
	
    switch (indexPath.row) {
        case 0:
            [cell loadCell:@"Étirements"];
            break;
        case 1:
            [cell loadCell:@"Informations"];
            break;
        default:
            break;
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
    
    switch (indexPath.row) {
        case 0: {
            EtirementsViewController *viewController = [[EtirementsViewController alloc] init];
            [[self navigationController]pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
        case 1: {
            QuestionsReponsesViewController *viewController = [[QuestionsReponsesViewController alloc] init];
            [[self navigationController]pushViewController:viewController animated:YES];
            [viewController release];   
        }
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    [othersTableView release];
    [super dealloc];
}

@end

