//
//  SDWebImageDownloader.h
//  ThePhoneHouseBOA
//
//  Created by Simon on 05/05/11.
//  Copyright 2011 The Phone House. All rights reserved.
//  Developed by Mobile's Republic.
//


#import <UIKit/UIKit.h>
#import "SDWebImageDownloaderDelegate.h"

extern NSString *const SDWebImageDownloadStartNotification;
extern NSString *const SDWebImageDownloadStopNotification;

@interface SDWebImageDownloader : NSObject
{
    @private
    NSURL *url;
    id<SDWebImageDownloaderDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *imageData;
	id userInfo;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) id<SDWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) id userInfo;

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<SDWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;

// This method is now no-op and is deprecated
+ (void)setMaxConcurrentDownloads:(NSUInteger)max __attribute__((deprecated));

@end
