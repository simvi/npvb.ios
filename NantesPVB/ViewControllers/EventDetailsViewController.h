//
//  EventDetailsViewController.h
//  Nantes PVB
//
//  Created by Damien Traille on 11/09/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailsViewController : UIViewController {
 
    BOOL isSubscribe;
    
    Event           *currentEvent;
    NSMutableArray  *membersArray;
    UIScrollView    *membersScrollView;
    UILabel         *connectionLabel;
    UILabel         *inscritsTitleLabel;
}

@property (nonatomic, retain) Event            *currentEvent;
@property (nonatomic, retain) NSMutableArray   *membersArray;
@property (nonatomic, retain) UIScrollView     *membersScrollView;
@property (nonatomic, retain) UILabel          *connectionLabel;
@property (nonatomic, retain) UILabel          *inscritsTitleLabel;

- (id)initWithEvent:(Event*)eventParam;

@end
