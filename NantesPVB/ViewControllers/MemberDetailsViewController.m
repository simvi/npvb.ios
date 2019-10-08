//
//  MemberDetailsViewController.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/29/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "MemberDetailsViewController.h"
#import <NantesPVB-Swift.h>

@implementation MemberDetailsViewController

@synthesize currentMenber;
@synthesize numeroAppel;

- (id)initWithMember:(Member*)memberParam {
    
    if (self = [super init]) {
        
        self.currentMenber = memberParam;
        [self loadTheView];
    
    }
    
    return self;
}

- (void)loadTheView {
    
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"Fiche membre"];
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
    CGFloat yForItems = 0.0;
    //if (IS_IOS_7) {
      //  yForItems = 40.0;
    //}
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, yForItems, self.view.frame.size.width, self.view.frame.size.height-yForItems)];
    [contentScrollView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    [contentScrollView setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:contentScrollView];
    [contentScrollView release];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 88.0)];
    [grayView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [grayView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    [contentScrollView addSubview:grayView];
    [grayView release];
    
    UIView *circleWhiteView = [[UIView alloc] initWithFrame:CGRectMake(20.0, 30.0, 100, 100)];
    [circleWhiteView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [[circleWhiteView layer] setCornerRadius:50.0];
    [contentScrollView addSubview:circleWhiteView];
    [circleWhiteView release];

    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3.0, 3.0, circleWhiteView.frame.size.width-6.0, circleWhiteView.frame.size.height-6.0)];
    [photoImageView setImageWithURL:[NSURL URLWithString:[currentMenber urlPhoto]] placeholderImage:[UIImage imageWithName:@"personne.png"]];
    [photoImageView setContentMode:(UIViewContentModeScaleAspectFill)];
    [photoImageView.layer setCornerRadius:(circleWhiteView.frame.size.width/2.0-3.0)];
    //[photoImageView.layer setBorderWidth:0.13];
    [photoImageView setClipsToBounds:YES];
    [circleWhiteView addSubview:photoImageView];
    [photoImageView release];
  
    // Nom et prenom
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, grayView.frame.size.height-40.0, grayView.frame.size.width-140.0, 40.0)];
    [nameLabel setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [currentMenber prenom], [currentMenber nom]]];
    [nameLabel setNumberOfLines:0];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [grayView addSubview:nameLabel];
    [nameLabel release];

    // Adresse
    UILabel *adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, grayView.frame.size.height+10.0, self.view.frame.size.width-130.0-10.0, 1.0)];
    [adressLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [adressLabel setBackgroundColor:[UIColor clearColor]];
    [adressLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [adressLabel setText:[NSString stringWithFormat:@"%@", [currentMenber adresse]]];
    [adressLabel setNumberOfLines:0];
    [adressLabel setFont:[UIFont systemFontOfSize:13.0]];
    [contentScrollView addSubview:adressLabel];
    [adressLabel release];

    CGFloat heightAdress = [[currentMenber adresse] sizeWithFont:[adressLabel font] constrainedToSize:CGSizeMake(adressLabel.frame.size.width, MAXFLOAT)].height;
    [adressLabel setFrame:CGRectMake(adressLabel.frame.origin.x, adressLabel.frame.origin.y, adressLabel.frame.size.width, heightAdress)];
    
    // Code Postal et Ville
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(adressLabel.frame.origin.x, adressLabel.frame.origin.y+heightAdress, adressLabel.frame.size.width, 1.0)];
    [cityLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [cityLabel setBackgroundColor:[UIColor clearColor]];
    [cityLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [cityLabel setNumberOfLines:0];
    [cityLabel setText:[NSString stringWithFormat:@"%@", [[[currentMenber codePostal] lowercaseString] capitalizedString]]];
    [cityLabel setFont:[UIFont systemFontOfSize:13.0]];
    [contentScrollView addSubview:cityLabel];
    [cityLabel release];

    CGFloat heightCity = [[cityLabel text] sizeWithFont:[cityLabel font] constrainedToSize:CGSizeMake(cityLabel.frame.size.width, MAXFLOAT)].height;
    [cityLabel setFrame:CGRectMake(cityLabel.frame.origin.x, cityLabel.frame.origin.y, cityLabel.frame.size.width, heightCity)];
    
    //
    CGFloat cumulatedHeight = cityLabel.frame.origin.y+50.0;
    int cpt = 0;
    for (NSString *telString in [currentMenber telephones]) {
        
        UIImageView *pictoTelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, cumulatedHeight, 20.0, 20.0)];
        [pictoTelImageView setImageName:@"picto_tel.png"];
        [contentScrollView addSubview:pictoTelImageView];
        [pictoTelImageView release];
        
        // Tel
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, pictoTelImageView.frame.origin.y, 200.0, pictoTelImageView.frame.size.height-1.0)];
        [telLabel setBackgroundColor:[UIColor clearColor]];
        [telLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [telLabel setText:[NSString stringWithFormat:@"%@", [telString lowercaseString]]];
        [telLabel setFont:[UIFont systemFontOfSize:13.0]];
        [contentScrollView addSubview:telLabel];
        [telLabel release];
        
        UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, telLabel.frame.origin.y-5, self.view.frame.size.width, telLabel.frame.size.height+10.0)];
        [telButton addTarget:self action:@selector(telAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [telButton setTag:cpt];
        [telButton setBackgroundColor:[UIColor clearColor]];
        [telButton setAlpha:0.5];
        [contentScrollView addSubview:telButton];
        [telButton release];
        
        cumulatedHeight += 40.0;
        cpt++;
    }
     

    
    
    //
    
    UIImageView *pictoMailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.0, cumulatedHeight, 20.0, 20.0)];
    [pictoMailImageView setImageName:@"picto_mail.png"];
    [contentScrollView addSubview:pictoMailImageView];
    [pictoMailImageView release];
    
    // Mail
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, pictoMailImageView.frame.origin.y, 200.0, pictoMailImageView.frame.size.height-1.0)];
    [mailLabel setBackgroundColor:[UIColor clearColor]];
    [mailLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [mailLabel setText:[NSString stringWithFormat:@"%@", [[currentMenber email] lowercaseString]]];
    [mailLabel setFont:[UIFont systemFontOfSize:13.0]];
    [contentScrollView addSubview:mailLabel];
    [mailLabel release];
    
    UIButton *mailButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, mailLabel.frame.origin.y-5, self.view.frame.size.width, mailLabel.frame.size.height+10.0)];
    [mailButton addTarget:self action:@selector(mailAction) forControlEvents:(UIControlEventTouchUpInside)];
    [mailButton setBackgroundColor:[UIColor clearColor]];
    [mailButton setAlpha:0.5];
    [contentScrollView addSubview:mailButton];
    [mailButton release];
    
        
    /*
    CGFloat cumulatedHeight = 5.0;

    UIImageView *photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 100.0, 100.0)];
    [photoImageView setImageWithURL:[NSURL URLWithString:[currentMenber urlPhoto]] placeholderImage:[UIImage imageWithName:@"personne.png"]];
    [photoImageView setContentMode:(UIViewContentModeScaleAspectFill)];
    [photoImageView.layer setCornerRadius:10.0];
    [photoImageView.layer setBorderWidth:0.13];
    [photoImageView setClipsToBounds:YES];
    [[self view] addSubview:photoImageView];
    [photoImageView release];
    
    // Nom et prenom
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((photoImageView.frame.origin.x*2)+photoImageView.frame.size.width, cumulatedHeight, 200.0, 30.0)];
    [nameLabel setBackgroundColor:[UIColor whiteColor]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [currentMenber prenom], [currentMenber nom]]];
    [nameLabel setNumberOfLines:0];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:nameLabel];
    [nameLabel release];

    cumulatedHeight += nameLabel.frame.size.height;
    
    // Telephone
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake((photoImageView.frame.origin.x*2)+photoImageView.frame.size.width, cumulatedHeight, 200.0, 30.0)];
    [phoneLabel setBackgroundColor:[UIColor whiteColor]];
    [phoneLabel setTextColor:[UIColor blackColor]];
    [phoneLabel setText:[NSString stringWithFormat:@"%@", [currentMenber telephone]]];
    [phoneLabel setNumberOfLines:0];
    [phoneLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:phoneLabel];
    [phoneLabel release];
    
    UIButton *phoneButton = [[UIButton alloc] initWithFrame:phoneLabel.frame];
    [phoneButton addTarget:self action:@selector(phoneAction) forControlEvents:(UIControlEventTouchUpInside)];
    [[self view] addSubview:phoneButton];
    [phoneButton release];
    
    cumulatedHeight += nameLabel.frame.size.height;
   
    // mail
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake((photoImageView.frame.origin.x*2)+photoImageView.frame.size.width, cumulatedHeight, 200.0, 30.0)];
    [mailLabel setBackgroundColor:[UIColor whiteColor]];
    [mailLabel setTextColor:[UIColor blackColor]];
    [mailLabel setText:[NSString stringWithFormat:@"%@", [currentMenber email]]];
    [mailLabel setNumberOfLines:0];
    [mailLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:mailLabel];
    [mailLabel release];

    UIButton *mailButton = [[UIButton alloc] initWithFrame:mailLabel.frame];
    [mailButton addTarget:self action:@selector(mailAction) forControlEvents:(UIControlEventTouchUpInside)];
    [[self view] addSubview:mailButton];
    [mailButton release];
    
    cumulatedHeight += mailLabel.frame.size.height+10.0;
     
    // Date de naissance
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, 300.0, 30.0)];
    [dateLabel setBackgroundColor:[UIColor whiteColor]];
    [dateLabel setTextColor:[UIColor blackColor]];
    [dateLabel setText:[NSString stringWithFormat:@"%@", [currentMenber dateNaissance]]];
    [dateLabel setNumberOfLines:0];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:dateLabel];
    [dateLabel release];
    
    cumulatedHeight += dateLabel.frame.size.height;
    
    // Title Adress
    UILabel *titleAdressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, 300.0, 30.0)];
    [titleAdressLabel setBackgroundColor:[UIColor whiteColor]];
    [titleAdressLabel setTextColor:[UIColor blackColor]];
    [titleAdressLabel setText:@"Addresse:"];
    [titleAdressLabel setNumberOfLines:0];
    [titleAdressLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:titleAdressLabel];
    [titleAdressLabel release];
    
    cumulatedHeight += titleAdressLabel.frame.size.height;
    
    // Adresse
    UILabel *adressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, 300.0, 30.0)];
    [adressLabel setBackgroundColor:[UIColor whiteColor]];
    [adressLabel setTextColor:[UIColor blackColor]];
    [adressLabel setText:[NSString stringWithFormat:@"%@ (%@)", [currentMenber adresse], [currentMenber codePostal]]];
    [adressLabel setNumberOfLines:0];
    [adressLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:adressLabel];
    [adressLabel release];
    
    cumulatedHeight += adressLabel.frame.size.height;
    
    // Title boulot
    UILabel *titleWorkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, 300.0, 30.0)];
    [titleWorkLabel setBackgroundColor:[UIColor whiteColor]];
    [titleWorkLabel setTextColor:[UIColor blackColor]];
    [titleWorkLabel setText:@"Profession:"];
    [titleWorkLabel setNumberOfLines:0];
    [titleWorkLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:titleWorkLabel];
    [titleWorkLabel release];
    
    cumulatedHeight += titleWorkLabel.frame.size.height;
    
    // Profession
    UILabel *workLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, cumulatedHeight, 300.0, 30.0)];
    [workLabel setBackgroundColor:[UIColor whiteColor]];
    [workLabel setTextColor:[UIColor blackColor]];
    [workLabel setText:[NSString stringWithFormat:@"%@", [currentMenber profession]]];
    [workLabel setNumberOfLines:0];
    [workLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [[self view] addSubview:workLabel];
    [workLabel release];
    
    cumulatedHeight += workLabel.frame.size.height;
    
    */
}

- (void)telAction:(id)sender {

    self.numeroAppel = [[currentMenber telephones] objectAtIndex:[sender tag]];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Contacter %@ ?", [currentMenber prenom]]
                                                        message:[NSString stringWithFormat:@"Numéro de téléphone: %@", numeroAppel]
                                                       delegate:self
                                              cancelButtonTitle:@"Annuler"
                                              otherButtonTitles:@"SMS", @"Appeler", nil];
    [alertView setTag:1];
    [alertView show];
    [alertView release];
    
}

- (void)mailAction {
            
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        
        if (mailClass != nil)
        {
            if ([mailClass canSendMail])
            {
                
                NSString *mail = [NSString stringWithFormat:@"%@", [currentMenber email]];
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                picker.mailComposeDelegate = self;
                [picker setToRecipients:[NSArray arrayWithObject:mail]];
                [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController]  presentViewController:picker animated:YES completion:nil];
                [picker release];
                
            }
            
        }
        
}





#pragma mark - alertView deletage

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        // SMS
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@", numeroAppel]]];
    }
    else if (buttonIndex == 2) {
        // Appel
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", numeroAppel]]];
    }
    
}

#pragma mark - Buttons

- (void)backAction {
    [[self navigationController] popViewControllerAnimated:YES];
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

#pragma mark - Memory

- (void)dealloc {
    [currentMenber release];
    [numeroAppel release];
    [super dealloc];
}

@end
