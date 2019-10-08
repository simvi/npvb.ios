//
//  MainTabbarController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNavigationController.h"
#import "CalendarNavigationController.h"
#import "MembersNavigationController.h"
#import "OthersNavigationController.h"
#import "CustomTabBarController.h"

@interface MainTabbarController : CustomTabBarController  {
 
    HomeNavigationController        *homeNavigationController;
    CalendarNavigationController    *calendarNavigationController;    
    MembersNavigationController     *membersNavigationController;    
    OthersNavigationController      *othersNavigationController;    

}

@property (nonatomic, retain) HomeNavigationController        *homeNavigationController;
@property (nonatomic, retain) CalendarNavigationController    *calendarNavigationController;    
@property (nonatomic, retain) MembersNavigationController     *membersNavigationController;    
@property (nonatomic, retain) OthersNavigationController      *othersNavigationController;    

- (id)initTabbarController;

@end
