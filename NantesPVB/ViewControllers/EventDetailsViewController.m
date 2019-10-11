//
//  EventDetailsViewController.m
//  Nantes PVB
//
//  Created by Damien Traille on 11/09/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "WSDatas.h"
#import "MemberDao.h"
#import <NantesPVB-Swift.h>

@implementation EventDetailsViewController

@synthesize currentEvent;
@synthesize membersArray;
@synthesize membersScrollView;
@synthesize connectionLabel;
@synthesize inscritsTitleLabel;

- (id)initWithEvent:(Event*)eventParam {
    
    if (self = [super init]) {
        
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        self.currentEvent = eventParam;
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:[dateFormatter stringFromDate:[currentEvent date]]];
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
        
        [self loadPresence];
        
        //
        
        [self loadTheView];
        
    }
    
    return self;
}

- (void)loadTheView {
    
    CGFloat cumulatedHeight = 10.0;
    CGFloat titleWidth = 100.0;
    
    // Libelle
    
    UILabel *typeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, titleWidth, 30.0)];
    [typeTitleLabel setBackgroundColor:[UIColor whiteColor]];
    [typeTitleLabel setText:@"Type: "];
    [typeTitleLabel setNumberOfLines:0];
    [typeTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [typeTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [[self view] addSubview:typeTitleLabel];
    [typeTitleLabel release];
    
    UILabel *libelleLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeTitleLabel.frame.origin.x+typeTitleLabel.frame.size.width, cumulatedHeight, 300.0, 30.0)];
    [libelleLabel setBackgroundColor:[UIColor whiteColor]];
    [libelleLabel setText:[NSString stringWithFormat:@"%@", [currentEvent libelle]]];
    [libelleLabel setNumberOfLines:0];
    [libelleLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
    [libelleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [[self view] addSubview:libelleLabel];
    [libelleLabel release];
    
    cumulatedHeight += libelleLabel.frame.size.height;
    
    UILabel *heureTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, titleWidth, 30.0)];
    [heureTitleLabel setBackgroundColor:[UIColor whiteColor]];
    [heureTitleLabel setText:@"Heure: "];
    [heureTitleLabel setNumberOfLines:0];
    [heureTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [heureTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [[self view] addSubview:heureTitleLabel];
    [heureTitleLabel release];
    
    NSDateFormatter *dateFormatterEvent = [[NSDateFormatter alloc] init];
    [dateFormatterEvent setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
    [dateFormatterEvent setDateFormat:@"HH:mm"];
    
    UILabel *heureLabel = [[UILabel alloc] initWithFrame:CGRectMake(heureTitleLabel.frame.origin.x+heureTitleLabel.frame.size.width, cumulatedHeight, 200.0, 30.0)];
    [heureLabel setBackgroundColor:[UIColor whiteColor]];
    [heureLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
    [heureLabel setText:[NSString stringWithFormat:@"%@", [dateFormatterEvent stringFromDate:[currentEvent date]]]];
    [heureLabel setNumberOfLines:0];
    [heureLabel setFont:[UIFont systemFontOfSize:14.0]];
    [[self view] addSubview:heureLabel];
    [heureLabel release];
    
    [dateFormatterEvent release];
    
    cumulatedHeight += heureLabel.frame.size.height;
    
    if ([[currentEvent adversaire] length] > 1) {
        
        UILabel *adversaireTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, titleWidth, 30.0)];
        [adversaireTitleLabel setBackgroundColor:[UIColor whiteColor]];
        [adversaireTitleLabel setText:@"Adversaire: "];
        [adversaireTitleLabel setNumberOfLines:0];
        [adversaireTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [adversaireTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [[self view] addSubview:adversaireTitleLabel];
        [adversaireTitleLabel release];
        
        UILabel *adversaireLabel = [[UILabel alloc] initWithFrame:CGRectMake(adversaireTitleLabel.frame.origin.x+adversaireTitleLabel.frame.size.width, cumulatedHeight, 200.0, 30.0)];
        [adversaireLabel setBackgroundColor:[UIColor whiteColor]];
        [adversaireLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [adversaireLabel setText:[currentEvent adversaire]];
        [adversaireLabel setNumberOfLines:0];
        [adversaireLabel setFont:[UIFont systemFontOfSize:14.0]];
        [[self view] addSubview:adversaireLabel];
        [adversaireLabel release];
        
        cumulatedHeight += adversaireLabel.frame.size.height;

    }
    
    if ([[currentEvent lieu] length] > 1) {
        
        UILabel *lieuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, titleWidth, 30.0)];
        [lieuTitleLabel setBackgroundColor:[UIColor whiteColor]];
        [lieuTitleLabel setText:@"Lieu: "];
        [lieuTitleLabel setNumberOfLines:0];
        [lieuTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [lieuTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [[self view] addSubview:lieuTitleLabel];
        [lieuTitleLabel release];
        
        NSMutableString *lieuString = [NSMutableString stringWithString:[currentEvent lieu]];
        [lieuString replaceOccurrencesOfString:@"Ã©" withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [lieuString length])];
        [lieuString replaceOccurrencesOfString:@"Ã¨" withString:@"è" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [lieuString length])];
        [lieuString replaceOccurrencesOfString:@"Ã«" withString:@"ë" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [lieuString length])];
        [lieuString replaceOccurrencesOfString:@"Ã" withString:@"à" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [lieuString length])];
        
        UILabel *lieuLabel = [[UILabel alloc] initWithFrame:CGRectMake(lieuTitleLabel.frame.origin.x+lieuTitleLabel.frame.size.width, cumulatedHeight, 200.0, 30.0)];
        [lieuLabel setBackgroundColor:[UIColor whiteColor]];
        [lieuLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [lieuLabel setText:[NSString stringWithFormat:@"%@", lieuString]];
        [lieuLabel setNumberOfLines:0];
        [lieuLabel setFont:[UIFont systemFontOfSize:14.0]];
        [[self view] addSubview:lieuLabel];
        [lieuLabel release];
        
        cumulatedHeight += lieuLabel.frame.size.height;
        
    }
    
    // Commentaires
    if ([[currentEvent comments] length] > 1) {

        UILabel *lieuTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, titleWidth, 30.0)];
        [lieuTitleLabel setBackgroundColor:[UIColor whiteColor]];
        [lieuTitleLabel setText:@"Lieu: "];
        [lieuTitleLabel setNumberOfLines:0];
        [lieuTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [lieuTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [[self view] addSubview:lieuTitleLabel];
        [lieuTitleLabel release];
        
        NSMutableString *commentString = [NSMutableString stringWithString:[currentEvent comments]];
        [commentString replaceOccurrencesOfString:@"Ã©" withString:@"é" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [commentString length])];
        [commentString replaceOccurrencesOfString:@"Ã¨" withString:@"è" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [commentString length])];
        [commentString replaceOccurrencesOfString:@"Ã«" withString:@"ë" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [commentString length])];
        [commentString replaceOccurrencesOfString:@"Ã" withString:@"à" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [commentString length])];
        
        UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(lieuTitleLabel.frame.origin.x+lieuTitleLabel.frame.size.width, cumulatedHeight, 200.0, 1.0)];
        [commentsLabel setBackgroundColor:[UIColor whiteColor]];
        [commentsLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [commentsLabel setText:[NSString stringWithFormat:@"%@", commentString]];
        [commentsLabel setNumberOfLines:0];
        [commentsLabel setFont:[UIFont systemFontOfSize:14.0]];
        [[self view] addSubview:commentsLabel];
        [commentsLabel release];
        
        CGFloat labelHeight = [[commentsLabel text] sizeWithAttributes:@{NSFontAttributeName: [commentsLabel font]}].height;
        commentsLabel.frame = CGRectMake(lieuTitleLabel.frame.origin.x+lieuTitleLabel.frame.size.width, cumulatedHeight, 200.0, labelHeight);
        
        cumulatedHeight += commentsLabel.frame.size.height + 10.0;
        
    }
    
    self.inscritsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight+7.0, titleWidth, 36.0)];
    [inscritsTitleLabel setBackgroundColor:[UIColor whiteColor]];
    [inscritsTitleLabel setText:@"Inscrits: "];
    [inscritsTitleLabel setNumberOfLines:0];
    [inscritsTitleLabel setAlpha:0.0];
    [inscritsTitleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [inscritsTitleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [[self view] addSubview:inscritsTitleLabel];
    [inscritsTitleLabel release];
    
    self.membersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(inscritsTitleLabel.frame.origin.x+inscritsTitleLabel.frame.size.width, cumulatedHeight+2.0, self.view.frame.size.width-(inscritsTitleLabel.frame.origin.x+inscritsTitleLabel.frame.size.width), self.view.frame.size.height-cumulatedHeight-96.0)];
    [membersScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    [[self view] addSubview:membersScrollView];
    [membersScrollView release];
    
    UIView *cacheView = [[UIView alloc] initWithFrame:CGRectMake(inscritsTitleLabel.frame.origin.x+inscritsTitleLabel.frame.size.width, cumulatedHeight, self.view.frame.size.width, 10.0)];
    [cacheView setBackgroundColor:[UIColor whiteColor]];
    [[self view] addSubview:cacheView];
    [cacheView release];
    
    cumulatedHeight += inscritsTitleLabel.frame.size.height;
    
    //
    
    if ([[currentEvent date] compare:[NSDate date]] != NSOrderedAscending) {
        // si currentEvent est pas inferieur à la date courante - evenement passé
        
        UIView *contentBtnView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-220.0, self.view.frame.size.height-65.0, 200.0, 40.0)];
        [contentBtnView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin)];
        [[self view] addSubview:contentBtnView];
        [contentBtnView release];
        
        UIImage *pictoImage = [UIImage imageNamed:@"icon_inscription.png"];
        UIImageView *pictoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentBtnView.frame.size.width-pictoImage.size.width, (contentBtnView.frame.size.height-pictoImage.size.height)/2.0, pictoImage.size.width, pictoImage.size.height)];
        [pictoImageView setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin)];
        [pictoImageView setImage:pictoImage];
        [contentBtnView addSubview:pictoImageView];
        [pictoImageView release];
        
        self.connectionLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, contentBtnView.frame.size.width-(pictoImageView.frame.size.width) - 10.0, contentBtnView.frame.size.height)] autorelease];
        [connectionLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [connectionLabel setBackgroundColor:[UIColor clearColor]];
        [connectionLabel setText:@"S'inscrire"];
        [connectionLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [connectionLabel setTextAlignment:NSTextAlignmentRight];
        [connectionLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentBtnView addSubview:connectionLabel];
        
        UIButton *inscriptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, contentBtnView.frame.size.width, contentBtnView.frame.size.height)];
        [inscriptionButton setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [inscriptionButton addTarget:self action:@selector(inscriptionAction) forControlEvents:(UIControlEventTouchUpInside)];
        [contentBtnView addSubview:inscriptionButton];
        [inscriptionButton release];
        
    }
    
}

- (void)loadPresence {
    
     [(AppDelegate*)[[UIApplication sharedApplication] delegate] showLoadingView:@"Chargement des inscrits ..."];
    
    [self performSelectorInBackground:@selector(loadPresencePerformed) withObject:nil];
    
}

- (void)loadPresencePerformed {
    @autoreleasepool {
        
        NSMutableArray *dictsArray = [WSDatas getPresencesForEvent:currentEvent];
        NSMutableArray *presentsArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in dictsArray) {

            if ([[dict objectForKey:@"Prevue"] isEqualToString:@"o"]) {
                if ([[dict objectForKey:@"Libelle"] isEqualToString:[currentEvent libelle]]) {
                    [presentsArray addObject:[dict objectForKey:@"Joueur"]];
                }
            }
            
        }

        if ([presentsArray count]>0) {
            self.membersArray = [MemberDao getMembersWithIds:presentsArray];
        }
        else {
            self.membersArray = nil;
        }

        [presentsArray release];

        [NSThread sleepForTimeInterval:1.0];
        
        [self performSelectorOnMainThread:@selector(loadPresenceFinished) withObject:nil waitUntilDone:NO];
    }
}

- (void)loadPresenceFinished {

    // Update UI in main thread
    if ([membersArray count] > 0) {
        [inscritsTitleLabel setAlpha:1.0];
        [inscritsTitleLabel setText:[NSString stringWithFormat:@"Inscrits:\n(%i)", (int)[membersArray count]]];
    }
    else {
        self.membersArray = nil;
        [inscritsTitleLabel setAlpha:0.0];
    }
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] hideLoadingView];
    
    for (UIView *subiview in [membersScrollView subviews]) {
        [subiview removeFromSuperview];
        subiview = nil;
    }
    
    isSubscribe = NO;
    
    int cpt = 0;
    for (Member *member in membersArray) {
        
        if ([[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] pseudonyme] isEqualToString:[member pseudonyme]]) {
            isSubscribe = YES;
        }
        
        UILabel *lieuLabel = [[UILabel alloc] initWithFrame:CGRectMake(00.0, cpt*30.0, membersScrollView.frame.size.width, 30.0)];
        [lieuLabel setBackgroundColor:[UIColor whiteColor]];
        [lieuLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [lieuLabel setText:[NSString stringWithFormat:@"%@ %@", [[member prenom] capitalizedString], [[member nom] capitalizedString]]];
        [lieuLabel setNumberOfLines:0];
        [lieuLabel setFont:[UIFont systemFontOfSize:14.0]];
        [membersScrollView addSubview:lieuLabel];
        [lieuLabel release];
        
        cpt++;
    }
    
    if (isSubscribe) {
        [connectionLabel setText:@"Se désinscrire"];
    }
    else {
        [connectionLabel setText:@"S'inscrire"];
    }
    
    [membersScrollView setContentSize:CGSizeMake(membersScrollView.frame.size.width, cpt*30.0)];
    
}

#pragma mark - Buttons

- (void)backAction {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)inscriptionAction {
    
    if ([(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember]) {
        
        // Si pas NPVB, alors pas un événenemtn de match, donc peut sincrire
        BOOL isOk = NO;
        if ([[currentEvent titre] rangeOfString:@"NPVB_L"].location == NSNotFound &&
            [[currentEvent titre] rangeOfString:@"NPVB_U"].location == NSNotFound &&
            [[currentEvent titre] rangeOfString:@"NPVB_F"].location == NSNotFound) {
            isOk = YES;
        }
        
        //DEBUG
        //NSLog(@"[currentEvent titre]: %@ / %i", [currentEvent titre], isOk);
        
        for (NSString *string in [[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] arrayOfAppartenances]) {

            //DEBUG
            //NSLog(@"string: %@", string);

            if ([string isEqualToString:[currentEvent titre]]) {
                isOk = YES;
            }
        }
        
        // Si c'est son equipe ou asso entrainement
        if (isOk) {
            
             [(AppDelegate*)[[UIApplication sharedApplication] delegate] showLoadingView:(isSubscribe?@"Désinscription en cours ...":@"Inscription en cours ...")];
            
            [self performSelectorInBackground:@selector(inscriptionPerformed) withObject:nil];
        }
        else {
            
            UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@"NPVB"
                                                                     message:@"Vous ne pouvez pas vous inscrire à cet événement."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"OK"
                                                           otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            
        }
        
    }
    else {
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] mainTabbarController] setSelectedIndex:0];
    }
    
}

#pragma mark - Inscription

- (void)inscriptionPerformed {
    @autoreleasepool {
        
        isSubscribe = NO;
        for (Member *member in membersArray) {
            if ([[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] pseudonyme] isEqualToString:[member pseudonyme]]) {
                isSubscribe = YES;
            }
        }
        
        [WSDatas inscriptionForEvent:currentEvent subscribe:!isSubscribe];
        
        [self performSelectorInBackground:@selector(loadPresencePerformed) withObject:nil];
        
    }
}

#pragma mark - Memory

- (void)dealloc {
    [currentEvent release];
    [membersArray release];
    [membersScrollView release];
    [connectionLabel release];
    [inscritsTitleLabel release];
    [super dealloc];
}

@end
