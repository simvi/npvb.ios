//
//  OtherTableViewCell.h
//  Nantes PVB
//
//  Created by Damien Traille on 13/11/2013.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTableViewCell : UITableViewCell {

    UILabel     *nameLabel;
    UIView      *grayView;

    
}

@property (nonatomic, retain) UILabel     *nameLabel;
@property (nonatomic, retain) UIView      *grayView;


- (void)loadCell:(NSString*)titleParam;

@end
