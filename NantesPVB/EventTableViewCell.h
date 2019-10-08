//
//  EventTableViewCell.h
//  Nantes PVB
//
//  Created by Damien Traille on 11/09/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventTableViewCell : UITableViewCell {
    
    UILabel         *titleLabel;
    UIImageView     *accessoryImageView;
    
}

@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UIImageView   *accessoryImageView;

- (void) loadEvent:(Event*)eventParam;

@end
