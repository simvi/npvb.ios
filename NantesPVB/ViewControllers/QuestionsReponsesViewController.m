//
//  QuestionsReponsesViewController.m
//  Nantes PVB
//
//  Created by Marc Lievremont on 07/01/14.
//  Copyright (c) 2014 Personnal. All rights reserved.
//

#import "QuestionsReponsesViewController.h"
#import <NantesPVB-Swift.h>

@implementation QuestionsReponsesViewController

- (id)init {
  
    if (self = [super init]) {
        
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"Informations"];
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
          //  yForItems = 60.0;
        //}
        
        // Mail
        UILabel *texteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, yForItems+10.0, 300.0, 250.0)];
        [texteLabel setBackgroundColor:[UIColor clearColor]];
        [texteLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [texteLabel setNumberOfLines:0];
        [texteLabel setText:@"Bienvenue sur Nantes PVB.\nAvec l'application, accédez à différentes fonctionnalités:\n-Inscription au évènements\n-Liste des joueurs\n-Accés à la fiche d'un joueur\n\nCette application a été développée par\nSimon VIAUD.\n\nPour toute remarque ou suggestion, vous pouvez le contacter par mail: simon.viaud@gmail.com."];
        [texteLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.view addSubview:texteLabel];
        [texteLabel release];
        
        UIButton *mailButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 100.0, 300.0, 150.0)];
        [mailButton addTarget:self action:@selector(mailAction) forControlEvents:(UIControlEventTouchUpInside)];
        [mailButton setBackgroundColor:[UIColor clearColor]];
        [texteLabel addSubview:mailButton];
        [mailButton release];
        
    }
    return self;
}


#pragma mark - Buttons

- (void)backAction {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)mailAction {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            
            NSString *mail = [NSString stringWithFormat:@"simon.viaud@gmail.com"];
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setToRecipients:[NSArray arrayWithObject:mail]];
            [[[(AppDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController]  presentViewController:picker animated:YES completion:nil];
            [picker release];
            
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

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {

    [super dealloc];
}

@end

