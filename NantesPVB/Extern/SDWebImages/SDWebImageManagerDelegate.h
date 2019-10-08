//
//  SDWebImageManagerDelegate.h
//  ThePhoneHouseBOA
//
//  Created by Simon on 05/05/11.
//  Copyright 2011 The Phone House. All rights reserved.
//  Developed by Mobile's Republic.
//


@class SDWebImageManager;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image;

@end
