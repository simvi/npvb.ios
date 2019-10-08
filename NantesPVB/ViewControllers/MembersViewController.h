//
//  MembersViewController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MembersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
   
    int selectedSort;
    
    NSMutableArray  *arrayOfMembers;
    UITableView     *membersTableView;
    UILabel         *nbMembersLabel;
    UIScrollView    *sortHeaderView;
    NSMutableArray  *sortArray;
    
}

@property (nonatomic, retain) NSMutableArray  *arrayOfMembers;
@property (nonatomic, retain) UITableView     *membersTableView;
@property (nonatomic, retain) UILabel         *nbMembersLabel;
@property (nonatomic, retain) UIScrollView    *sortHeaderView;
@property (nonatomic, retain) NSMutableArray  *sortArray;

@end
