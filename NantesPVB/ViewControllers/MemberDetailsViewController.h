//
//  MemberDetailsViewController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/29/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"
#import <MessageUI/MessageUI.h>

@interface MemberDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate> {
    Member      *currentMenber;
    NSString    *numeroAppel;
}

@property (nonatomic, retain) Member        *currentMenber;
@property (nonatomic, retain) NSString      *numeroAppel;

- (id)initWithMember:(Member*)memberParam;

@end
