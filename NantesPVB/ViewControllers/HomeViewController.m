//
//  HomeViewController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "HomeViewController.h"
#import "MemberDao.h"
#import "WSDatas.h"
#import "AppartenancesDao.h"
#import <NantesPVB-Swift.h>

@implementation HomeViewController

@synthesize homeWebView;
@synthesize contentScrollView;
@synthesize idTextField;
@synthesize pwdTextField;
@synthesize bgPwdView;
@synthesize bgIdView;
@synthesize connectedScrollView;
@synthesize connectedLabel;
@synthesize photoImageView;

- (id)init {
 
    if (self = [super init]) {
        
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Nantes Plaisir du Volley-Ball"];
        [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        [[self navigationItem] setTitleView:titleLabel];
        [titleLabel release];
        
        //
        
        self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [contentScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        [contentScrollView setDelegate:self];
        [contentScrollView setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:contentScrollView];
        [contentScrollView release];
        
        CGFloat cumulatedHeight = 0.0;

        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-320.0)/2.0, cumulatedHeight, 320.0, 160.0)];
        [introLabel setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [introLabel setBackgroundColor:[UIColor clearColor]];
        [introLabel setText:@"Bienvenue à tous les sportifs !\nNPVB est un club de volley Loisirs, dont les mots\nd'ordre principaux sont :\n\"détente, plaisir et progrès collectif\"."];
        [introLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [introLabel setNumberOfLines:0];
        [introLabel setTextAlignment:NSTextAlignmentCenter];
        [introLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentScrollView addSubview:introLabel];
        [introLabel release];
        
        cumulatedHeight += introLabel.frame.size.height;
        
        //
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, cumulatedHeight, 280.0, 20.0)];
        [idLabel setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [idLabel setBackgroundColor:[UIColor clearColor]];
        [idLabel setText:@"Identifiant :"];
        [idLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [idLabel setTextAlignment:NSTextAlignmentLeft];
        [idLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentScrollView addSubview:idLabel];
        [idLabel release];
        
        cumulatedHeight += idLabel.frame.size.height + 10.0;
        
        self.bgIdView = [[UIView alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, cumulatedHeight, 280.0, 30.0)];
        [bgIdView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [bgIdView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]];
        [[bgIdView layer] setCornerRadius:5.0];
        [contentScrollView addSubview:bgIdView];
        [bgIdView release];
        
        self.idTextField = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 4.0, bgIdView.frame.size.width-5.0, 22.0)];
        [idTextField setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        [idTextField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [idTextField setAutocorrectionType:(UITextAutocorrectionTypeNo)];
        [idTextField setBackgroundColor:[UIColor clearColor]];
        [idTextField setReturnKeyType:(UIReturnKeyNext)];
        [idTextField setDelegate:self];
        [bgIdView addSubview:idTextField];
        [idTextField release];
        
        UIButton *idButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 160.0, contentScrollView.frame.size.width-55.0, 70.0)];
        [idButton setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [idButton addTarget:self action:@selector(idAction) forControlEvents:(UIControlEventTouchUpInside)];
        [contentScrollView addSubview:idButton];
        [idButton release];
        
        cumulatedHeight += bgIdView.frame.size.height + 10.0;
        
        //
        
        UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, cumulatedHeight, 280.0, 20.0)];
        [pwdLabel setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [pwdLabel setBackgroundColor:[UIColor clearColor]];
        [pwdLabel setText:@"Mot de passe :"];
        [pwdLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [pwdLabel setTextAlignment:NSTextAlignmentLeft];
        [pwdLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentScrollView addSubview:pwdLabel];
        [pwdLabel release];
        
        cumulatedHeight += pwdLabel.frame.size.height + 10.0;

        self.bgPwdView = [[UIView alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, cumulatedHeight, 280.0, 30.0)];
        [bgPwdView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [bgPwdView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]];
        [[bgPwdView layer] setCornerRadius:5.0];
        [contentScrollView addSubview:bgPwdView];
        [bgPwdView release];
        
        self.pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 4.0, bgPwdView.frame.size.width-5.0, 22.0)];
        [pwdTextField setAutocapitalizationType:(UITextAutocapitalizationTypeNone)];
        [pwdTextField setClearButtonMode:(UITextFieldViewModeWhileEditing)];
        [pwdTextField setAutocorrectionType:(UITextAutocorrectionTypeNo)];
        [pwdTextField setBackgroundColor:[UIColor clearColor]];
        [pwdTextField setReturnKeyType:(UIReturnKeyNext)];
        [pwdTextField setSecureTextEntry:YES];
        [pwdTextField setDelegate:self];
        [bgPwdView addSubview:pwdTextField];
        [pwdTextField release];
        
        UIButton *pwdButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 230.0, contentScrollView.frame.size.width-55.0, 60.0)];
        [pwdButton setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        //[pwdButton setBackgroundColor:[UIColor redColor]];
        //[pwdButton setAlpha:0.5];
        [pwdButton addTarget:self action:@selector(pwdAction) forControlEvents:(UIControlEventTouchUpInside)];
        [contentScrollView addSubview:pwdButton];
        [pwdButton release];
        
        cumulatedHeight += bgPwdView.frame.size.height + 10.0;

        //
        
        UIView *contentBtnView = [[UIView alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, cumulatedHeight, 280.0, 44.0)];
        [contentBtnView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [contentBtnView setBackgroundColor:[UIColor clearColor]];
        [contentScrollView addSubview:contentBtnView];
        [contentBtnView release];
        
        UIImage *pictoImage = [UIImage imageNamed:@"icon_connect.png"];
        UIImageView *pictoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentBtnView.frame.size.width-pictoImage.size.width, (contentBtnView.frame.size.height-pictoImage.size.height)/2.0, pictoImage.size.width, pictoImage.size.height)];
        [pictoImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [pictoImageView setImage:pictoImage];
        [contentBtnView addSubview:pictoImageView];
        [pictoImageView release];
        
        UILabel *connectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, contentBtnView.frame.size.width-pictoImage.size.width-10.0, contentBtnView.frame.size.height)];
        [connectionLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [connectionLabel setBackgroundColor:[UIColor clearColor]];
        [connectionLabel setText:@"Connexion"];
        [connectionLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [connectionLabel setTextAlignment:NSTextAlignmentRight];
        [connectionLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentBtnView addSubview:connectionLabel];
        [connectionLabel release];
        
        UIButton *connectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, contentBtnView.frame.size.width, contentBtnView.frame.size.height)];
        [connectionButton setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [connectionButton addTarget:self action:@selector(connectionAction) forControlEvents:(UIControlEventTouchUpInside)];
        [contentBtnView addSubview:connectionButton];
        [connectionButton release];
        
        cumulatedHeight += contentBtnView.frame.size.height + 10.0;

        [contentScrollView setContentSize:(CGSizeMake(0.0, cumulatedHeight))];

        ///
        
        self.connectedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height)];
        [connectedScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
        [connectedScrollView setAlpha:0.0];
        [connectedScrollView setBackgroundColor:[UIColor clearColor]];
        [[self view] addSubview:connectedScrollView];
        [connectedScrollView release];
        
        UILabel *connectedDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 44.0, self.view.frame.size.width, 20.0)];
        [connectedDescLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [connectedDescLabel setBackgroundColor:[UIColor clearColor]];
        [connectedDescLabel setText:@"Vous êtes connecté en tant que :"];
        [connectedDescLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [connectedDescLabel setNumberOfLines:0];
        [connectedDescLabel setTextAlignment:NSTextAlignmentCenter];
        [connectedDescLabel setFont:[UIFont systemFontOfSize:13.0]];
        [connectedScrollView addSubview:connectedDescLabel];
        [connectedDescLabel release];
        
        self.connectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 70.0, self.view.frame.size.width, 20.0)];
        [connectedLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
        [connectedLabel setBackgroundColor:[UIColor clearColor]];
        [connectedLabel setText:[NSString stringWithFormat:@"%@ %@", [[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] prenom], [[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] nom]]];
        [connectedLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [connectedLabel setNumberOfLines:0];
        [connectedLabel setTextAlignment:NSTextAlignmentCenter];
        [connectedLabel setFont:[UIFont systemFontOfSize:15.0]];
        [connectedScrollView addSubview:connectedLabel];
        [connectedLabel release];
        
        UIView *circleWhiteView = [[UIView alloc] initWithFrame:CGRectMake((connectedScrollView.frame.size.width-100.0)/2.0, 110.0, 100.0, 100.0)];
        [circleWhiteView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [circleWhiteView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
        [[circleWhiteView layer] setCornerRadius:50.0];
        [connectedScrollView addSubview:circleWhiteView];
        [circleWhiteView release];
        
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 3.0, circleWhiteView.frame.size.width-6.0, circleWhiteView.frame.size.height-6.0)];
        [photoImageView setImageWithURL:[NSURL URLWithString:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] urlPhoto]] placeholderImage:[UIImage imageWithName:@"personne.png"]];
        [photoImageView setContentMode:(UIViewContentModeScaleAspectFill)];
        [photoImageView.layer setCornerRadius:(circleWhiteView.frame.size.width/2.0-3.0)];
        [photoImageView setClipsToBounds:YES];
        [circleWhiteView addSubview:photoImageView];
        [photoImageView release];

        ///
        
        UIView *contentDeconnectBtnView = [[UIView alloc] initWithFrame:CGRectMake((contentScrollView.frame.size.width-280.0)/2.0, 305.0, 280.0, 44.0)];
        [contentDeconnectBtnView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        [contentDeconnectBtnView setBackgroundColor:[UIColor clearColor]];
        [connectedScrollView addSubview:contentDeconnectBtnView];
        [contentDeconnectBtnView release];
        
        UIImageView *pictoDeconnectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentDeconnectBtnView.frame.size.width-pictoImage.size.width, (contentDeconnectBtnView.frame.size.height-pictoImage.size.height)/2.0, pictoImage.size.width, pictoImage.size.height)];
        [pictoDeconnectImageView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)];
        [pictoDeconnectImageView setImage:pictoImage];
        [contentDeconnectBtnView addSubview:pictoDeconnectImageView];
        [pictoDeconnectImageView release];
        
        UILabel *disconnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, contentDeconnectBtnView.frame.size.width-pictoImage.size.width-10.0, contentDeconnectBtnView.frame.size.height)];
        [disconnectLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [disconnectLabel setBackgroundColor:[UIColor clearColor]];
        [disconnectLabel setText:@"Se déconnecter"];
        [disconnectLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [disconnectLabel setTextAlignment:NSTextAlignmentRight];
        [disconnectLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentDeconnectBtnView addSubview:disconnectLabel];
        [disconnectLabel release];
        
        UIButton *disconnectButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, contentDeconnectBtnView.frame.size.width, contentDeconnectBtnView.frame.size.height)];
        [disconnectButton setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [disconnectButton addTarget:self action:@selector(deconnectionAction) forControlEvents:(UIControlEventTouchUpInside)];
        [contentDeconnectBtnView addSubview:disconnectButton];
        [disconnectButton release];

        
        /*
        UILabel *deconnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 305.0, 200.0, 20.0)];
        [deconnectionLabel setBackgroundColor:[UIColor clearColor]];
        [deconnectionLabel setText:@"Se déconnecter"];
        [deconnectionLabel setTextColor:[UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0]];
        [deconnectionLabel setTextAlignment:NSTextAlignmentCenter];
        [deconnectionLabel setFont:[UIFont systemFontOfSize:13.0]];
        [connectedScrollView addSubview:deconnectionLabel];
        [deconnectionLabel release];
        
        UIImageView *pictoDeconectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-20.0-pictoImage.size.width, 305.0, pictoImage.size.width, pictoImage.size.height)];
        [pictoDeconectImageView setImage:pictoImage];
        [connectedScrollView addSubview:pictoDeconectImageView];
        [pictoDeconectImageView release];
        
        UIButton *deconnectionButton = [[UIButton alloc] initWithFrame:CGRectMake(180.0, 295.0, 150.0, 44.0)];
        [deconnectionButton setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin)];
        //[connectionButton setTitle:@"Se connecter" forState:(UIControlStateNormal)];
        //[connectionButton setAlpha:0.1];
        //[connectionButton setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:193.0/255.0 blue:6.0/255.0 alpha:1.0]];
        [deconnectionButton addTarget:self action:@selector(deconnectionAction) forControlEvents:(UIControlEventTouchUpInside)];
        [connectedScrollView addSubview:deconnectionButton];
        [deconnectionButton release];*/
        
        //
        
        [[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"] length]>0) {
            [idTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"]];
        }
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"] length]>0) {
            [pwdTextField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"member_pwd"]];
        }
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    id tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:@"Accueil" value:@""];
//    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
}

#pragma mark - UIButton target

- (void)idAction {
  
    [idTextField becomeFirstResponder];
    
    if (self.view.frame.size.height < 500.0) {
        [contentScrollView setContentOffset:CGPointMake(0.0, bgIdView.frame.origin.y-40.0) animated:YES];
    }

    [self setDoneButton];
    
}

- (void)pwdAction {

    [pwdTextField becomeFirstResponder];

    if (self.view.frame.size.height < 500.0) {
        [contentScrollView setContentOffset:CGPointMake(0.0, bgIdView.frame.origin.y-40.0) animated:YES];
    }
    
    [self setDoneButton];

}

- (void)setDoneButton {
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"Nantes PVB"];
    [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [[self navigationItem] setTitleView:titleLabel];
    [titleLabel release];
    
    //btn retour
    UIView *doneView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    
    UILabel *okLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    [okLabel setBackgroundColor:[UIColor clearColor]];
    [okLabel setText:@"OK"];
    [okLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [okLabel setTextAlignment:NSTextAlignmentCenter];
    [okLabel setFont:[UIFont systemFontOfSize:17.0]];
    [doneView addSubview:okLabel];
    [okLabel release];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, doneView.frame.size.width, doneView.frame.size.height)];
    [doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [doneView addSubview:doneButton];
    [doneButton release];
    
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneView];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
    [doneView release];
    
    //
}

- (void)doneAction {
    
    [idTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"Nantes Plaisir du Volley-Ball"];
    [titleLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [[self navigationItem] setTitleView:titleLabel];
    [titleLabel release];
    
}

- (void)connectionAction {
    
    // On passe en majuscule pour les tests futurs
    [idTextField setText:[[idTextField text] uppercaseString]];
    
    [self doneAction];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showLoadingView:@"Connexion en cours ..."];

    [self performSelectorInBackground:@selector(connectionPerformed:) withObject:@[[idTextField text], [pwdTextField text]]];


}

- (void)connectionPerformed:(NSArray*)credentials {

    @autoreleasepool {
        NSString *userId = credentials[0];
        NSString *pwd = credentials[1];
        BOOL response = [WSDatas connectionWithId: userId andPwd:pwd];

        [NSThread sleepForTimeInterval:1.0];

        [self performSelectorOnMainThread:@selector(connectionFinished:) withObject:[NSNumber numberWithBool:response] waitUntilDone:NO];
    }
    
    
}


- (void)connectionFinished:(NSNumber*)response {
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] hideLoadingView];
    
    if ([response intValue] == 0) {
        
        UIAlertView *testALertView =  [[UIAlertView alloc] initWithTitle:@"Erreur"
                                                                 message:@"Connexion impossible"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
        [testALertView show];
        [testALertView release];
        
    }
    else {
        
        Member *member = [MemberDao getMemberWithId:[idTextField text]];
       
        if (member) {
            
            [member setArrayOfAppartenances:[AppartenancesDao getAppartenances:[idTextField text]]];

            //NSLog(@"connection member arrayOfAppartenances] count: %i", (int)[[member arrayOfAppartenances] count]);
            
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] setConnectedMember:member];
            
            [connectedLabel setText:[NSString stringWithFormat:@"%@ %@", [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] prenom] uppercaseString], [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] nom] uppercaseString]]];
            [photoImageView setImageWithURL:[NSURL URLWithString:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] urlPhoto]] placeholderImage:[UIImage imageWithName:@"personne.png"]];
            
            //NSLog(@"[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] urlPhoto]: %@", [[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] urlPhoto]);
            
            [connectedScrollView setAlpha:1.0];
            [contentScrollView setAlpha:0.0];
            
            [[NSUserDefaults standardUserDefaults] setObject:[idTextField text] forKey:@"member_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[pwdTextField text] forKey:@"member_pwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else {
            [connectedScrollView setAlpha:0.0];
            [contentScrollView setAlpha:1.0];
        }
        
    }

}

- (void)deconnectionAction {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"member_id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"member_pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [connectedScrollView setAlpha:0.0];
    [contentScrollView setAlpha:1.0];
}

#pragma mark - Texfield Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {

}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (void) keyboardWillShow:(NSNotification *)note {
    
    // get keyboard size and location
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
    //[contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height-keyboardBounds.size.height+49.0)];

    // commit animations
	[UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)note {
    
    [contentScrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];

    /*
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

    // resize de la tableview
   // [contentScrollView setFrame:CGRectMake(contentScrollView.frame.origin.x, contentScrollView.frame.origin.y, contentScrollView.frame.size.width, self.view.frame.size.height)];

	// commit animations
	[UIView commitAnimations];
    */
    
}


#pragma mark - Scrollview Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollView.contentOffset.y:%f", scrollView.contentOffset.y);
}


#pragma mark - Memory

- (void)dealloc {
    
    [homeWebView        release];
    [contentScrollView  release];
    [idTextField        release];
    [pwdTextField       release];
    [bgPwdView          release];
    [bgIdView           release];
    [connectedScrollView release];
    [connectedLabel     release];
    [photoImageView     release];

    [super dealloc];
}

@end

