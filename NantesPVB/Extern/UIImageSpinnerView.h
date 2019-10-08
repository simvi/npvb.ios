//
//  UIImageSpinnerView.h
//  ThePhoneHouseBOA
//
//  Created by Damien Traille on 24/05/11.
//  Copyright 2011 DPC Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"

@interface UIImageSpinnerView : UIView <SDWebImageDownloaderDelegate> {
    
    UIImageView                 *currentImageView;
    UIActivityIndicatorView     *activityIndicatorView;
    NSThread                    *threadImage;
    
}

@property (nonatomic, retain) UIImageView                 *currentImageView;
@property (nonatomic, retain) UIActivityIndicatorView     *activityIndicatorView;
@property (nonatomic, retain) NSThread                    *threadImage;

- (void) setImageWithUrl:(NSURL*)urlParam;

@end
