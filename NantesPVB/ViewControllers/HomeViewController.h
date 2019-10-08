//
//  HomeViewController.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate> {

    UIWebView       *homeWebView;
    UIScrollView    *contentScrollView;
    UITextField     *idTextField;
    UITextField     *pwdTextField;
    UIView          *bgPwdView;
    UIView          *bgIdView;
    UIScrollView    *connectedScrollView;
    UILabel         *connectedLabel;
    UIImageView     *photoImageView;

}

@property (nonatomic, retain) UIWebView       *homeWebView;
@property (nonatomic, retain) UIScrollView    *contentScrollView;
@property (nonatomic, retain) UITextField     *idTextField;
@property (nonatomic, retain) UITextField     *pwdTextField;
@property (nonatomic, retain) UIView          *bgPwdView;
@property (nonatomic, retain) UIView          *bgIdView;
@property (nonatomic, retain) UIView          *idContentView;
@property (nonatomic, retain) UIScrollView    *connectedScrollView;
@property (nonatomic, retain) UILabel         *connectedLabel;
@property (nonatomic, retain) UIImageView     *photoImageView;

- (void)setDoneButton;

@end
