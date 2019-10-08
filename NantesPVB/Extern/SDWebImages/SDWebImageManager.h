//
//  SDWebImageManager.h
//  ThePhoneHouseBOA
//
//  Created by Simon on 05/05/11.
//  Copyright 2011 The Phone House. All rights reserved.
//  Developed by Mobile's Republic.
//


#import <UIKit/UIKit.h>
#import "SDWebImageDownloaderDelegate.h"
#import "SDWebImageManagerDelegate.h"
#import "SDImageCacheDelegate.h"

@interface SDWebImageManager : NSObject <SDWebImageDownloaderDelegate, SDImageCacheDelegate>
{
    NSMutableArray *delegates;
    NSMutableArray *downloaders;
    NSMutableDictionary *downloaderForURL;
    NSMutableArray *failedURLs;
}

+ (id)sharedManager;
- (UIImage *)imageWithURL:(NSURL *)url;
- (void)downloadWithURL:(NSURL *)url delegate:(id<SDWebImageManagerDelegate>)delegate;
- (void)cancelForDelegate:(id<SDWebImageManagerDelegate>)delegate;

@end
