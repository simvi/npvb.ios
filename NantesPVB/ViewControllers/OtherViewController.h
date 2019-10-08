//
//  OtherViewController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    UITableView *othersTableView;
    int nbLines;
}

@property (nonatomic, retain) UITableView *othersTableView;

@end
