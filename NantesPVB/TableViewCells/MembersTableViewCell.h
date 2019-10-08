//
//  MembersTableViewCell.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface MembersTableViewCell : UITableViewCell {

    UIImageView *photoImageView;
    UILabel     *nameLabel;
    UILabel     *teamLabel;
    UILabel     *phoneLabel;
    UIView      *grayView;
    UIImageView *accessoryImageView;
    BOOL        isFirst;
    BOOL        isLast;
}

@property (nonatomic, retain) UIImageView *photoImageView;
@property (nonatomic, retain) UILabel     *nameLabel;
@property (nonatomic, retain) UILabel     *teamLabel;
@property (nonatomic, retain) UILabel     *phoneLabel;
@property (nonatomic, retain) UIView      *grayView;
@property (nonatomic, retain) UIImageView *accessoryImageView;
@property (nonatomic, assign) BOOL        isFirst;
@property (nonatomic, assign) BOOL        isLast;

- (void) loadMember:(Member*)memberParam;

@end
