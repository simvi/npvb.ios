//
//  MembersViewController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "MembersViewController.h"
#import "MembersTableViewCell.h"
#import "MemberDetailsViewController.h"
#import "WSDatas.h"
#import "AppartenancesDAO.h"
#import "MemberDao.h"
#import <NantesPVB-Swift.h>

@implementation MembersViewController

@synthesize arrayOfMembers;
@synthesize membersTableView;
@synthesize nbMembersLabel;
@synthesize sortHeaderView;
@synthesize sortArray;

- (id)init {
    
    if ((self = [super init])) {
        
        ///
        
        // Notif de mise à jour des données
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDatas)
                                                     name:@"NPVB_DataUpdate"
                                                   object:nil];
        ///
        
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Membres"];
        [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [[self navigationItem] setTitleView:titleLabel];
        [titleLabel release];
        
        ////
        
        self.sortHeaderView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40.0)] autorelease];
        [sortHeaderView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [sortHeaderView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]];
        [sortHeaderView setShowsHorizontalScrollIndicator:NO];
        [[self view] addSubview:sortHeaderView];
        
        [self loadSortHeader];
        
        ////
        
        self.membersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, (sortHeaderView.frame.origin.y+sortHeaderView.frame.size.height), self.view.frame.size.width, self.view.frame.size.height-(sortHeaderView.frame.origin.y+sortHeaderView.frame.size.height))];
        [membersTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [membersTableView setDelegate:self];
        [membersTableView setDataSource:self];
        [membersTableView setEditing:NO animated:NO];
        [membersTableView setBackgroundColor:[UIColor whiteColor]];
        [membersTableView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
        [[self view] addSubview:membersTableView];
        [membersTableView release];
        
        self.nbMembersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, membersTableView.frame.size.width, 40.0)];
        [nbMembersLabel setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        [nbMembersLabel setTextAlignment:(NSTextAlignmentCenter)];
        [nbMembersLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [nbMembersLabel setText:@""];
        [nbMembersLabel setNumberOfLines:0];
        [nbMembersLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [membersTableView setTableHeaderView:nbMembersLabel];
        [nbMembersLabel release];
        
        // Btn mail
        
        UIImage *mailImage = [UIImage imageNamed:@"navbar_mail.png"];
        UIImageView *mailImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, mailImage.size.width, mailImage.size.height)] autorelease];
        [mailImageView setImage:mailImage];
        UIButton *mailButton = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, mailImage.size.width, mailImage.size.height)] autorelease];
        [mailButton addTarget:self action:@selector(mailAction) forControlEvents:(UIControlEventTouchUpInside)];
        [mailImageView addSubview:mailButton];
        UIBarButtonItem *mailBarButton = [[UIBarButtonItem alloc] initWithCustomView:mailImageView];
        [[self navigationItem] setRightBarButtonItem:mailBarButton animated:NO];
        
    }
    
    return self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self reloadDatas];
    
}

- (void)reloadDatas {
    
    self.arrayOfMembers = [MemberDao getMembers];
    
    [membersTableView reloadData];
    [nbMembersLabel setText:[NSString stringWithFormat:@"Il y actuellement %i inscrits au club.", (int)[arrayOfMembers count]]];
    
    [self loadSortHeader];

}

- (void)loadSortHeader {
    
    for (UIView *subiview in [sortHeaderView subviews]) {
        [subiview removeFromSuperview];
    }
    
    self.sortArray = [AppartenancesDAO getEquipes];
    
    CGFloat cumulatedX = 5.0;
    int cpt = 0;
    for (NSString *team in sortArray) {
        
        UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(cumulatedX, 5.0, 100.0, 30.0)];
        [teamLabel setText:team];
        [teamLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [teamLabel setTextAlignment:(NSTextAlignmentCenter)];
        [teamLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [[teamLabel layer] setBorderColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0].CGColor];
        [[teamLabel layer] setBorderWidth:1.0];
        [teamLabel setTag:cpt];
        [sortHeaderView addSubview:teamLabel];
        [teamLabel release];
        
        UIButton *teamButton = [[UIButton alloc] initWithFrame:CGRectMake(cumulatedX, 0.0, 100.0, 40.0)];
        [teamButton setTag:cpt];
        [teamButton addTarget:self action:@selector(sortAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [sortHeaderView addSubview:teamButton];
        [teamButton release];
        
        if ([team isEqualToString:@"Tous"]) {
            [teamLabel setTextColor:[UIColor whiteColor]];
        }
        
        cumulatedX += teamButton.frame.size.width-1.0;
        
        cpt++;
        
    }
    
    [sortHeaderView setContentSize:CGSizeMake(cumulatedX+5.0, 1.0)];
    [sortHeaderView setContentOffset:CGPointMake(0.0, 0.0)];
    
}

#pragma mark - Buttons

- (void)sortAction:(UIButton*)btnParam {
    
    // On garde le bouton selectionné
    selectedSort = (int)[btnParam tag];
    
    //On passe en blanc le selectionnner, en gris les autres
    for (UIView *subiview in [sortHeaderView subviews]) {
        
        if ([subiview isKindOfClass:[UILabel class]] && [subiview tag] == selectedSort) {
            [(UILabel*)subiview setTextColor:[UIColor whiteColor]];
        }
        else if ([subiview isKindOfClass:[UILabel class]]) {
            [(UILabel*)subiview setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        }
        
    }
    
    NSString *sortString = [sortArray objectAtIndex:selectedSort];
    
    if ([sortString isEqualToString:@"Tous"]) {
        
        self.arrayOfMembers = [MemberDao getMembers];
        
    }
    else {
        
        self.arrayOfMembers = [MemberDao getMembersWithTeam:sortString];
        
    }
    
    [membersTableView reloadData];
    
    [membersTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
    
}

- (void)mailAction {
    
    NSString *text = @"";
    if (selectedSort == 0) {
        text = @"Etes vous sûr de vouloir envoyer un mail à tous les adhérents ?";
    }
    else {
        NSString *sortString = [sortArray objectAtIndex:selectedSort];
        text = [NSString stringWithFormat:@"Etes vous sûr de vouloir envoyer un mail aux joueurs de '%@' ?", sortString];
    }
    
    UIAlertView *mailAlertView = [[[UIAlertView alloc] initWithTitle:@""
                                                             message:text
                                                            delegate:self
                                                   cancelButtonTitle:@"Annuler"
                                                   otherButtonTitles:@"Oui", nil] autorelease];
    [mailAlertView show];
    
    
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        
        if (mailClass != nil)
        {
            if ([mailClass canSendMail])
            {
                
                NSMutableArray *mailsArray = [NSMutableArray array];
                for (Member *member in arrayOfMembers) {
                    if ([[member email] length]>1) {
                        [mailsArray addObject:[member email]];
                    }
                }
                
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                [picker setMailComposeDelegate:self];
                [picker setToRecipients:mailsArray];
                [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:picker animated:YES completion:^{}];
                [picker release];
                
            }
            
        }
        
    }
    
}

#pragma mark - MFMessageComposeViewController Delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Erreur inconnu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    
    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayOfMembers count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MembersTableViewCell *cell = (MembersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MembersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:(UITableViewCellAccessoryNone)];
    [cell loadMember:[arrayOfMembers objectAtIndex:indexPath.row]];
    
    if (indexPath.row==0) {
        [cell setIsFirst:YES];
    }
    else {
        [cell setIsFirst:NO];
    }
    
    if (indexPath.row==[arrayOfMembers count]-1) {
        [cell setIsLast:YES];
    }
    else {
        [cell setIsLast:NO];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // On vérifie que c'est un membre: il s'est déjà connecté
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] length] > 0 &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"] length] > 0) {
        
        MemberDetailsViewController *viewController = [[MemberDetailsViewController alloc] initWithMember:[arrayOfMembers objectAtIndex:indexPath.row]];
        [[self navigationController]pushViewController:viewController animated:YES];
        [viewController release];
        
    }
    
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NPVB_DataUpdate" object:nil];
    
    [arrayOfMembers     release];
    [membersTableView   release];
    [nbMembersLabel     release];
    [sortHeaderView     release];
    [sortArray          release];
    
    [super dealloc];
    
}

@end

