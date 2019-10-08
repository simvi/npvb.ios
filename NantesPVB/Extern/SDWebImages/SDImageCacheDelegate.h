//
//  SDImageCacheDelegate.h
//  ThePhoneHouseBOA
//
//  Created by Simon on 05/05/11.
//  Copyright 2011 The Phone House. All rights reserved.
//  Developed by Mobile's Republic.
//


#import <UIKit/UIKit.h>

@class SDImageCache;

@protocol SDImageCacheDelegate <NSObject>

@optional
- (void)imageCache:(SDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)imageCache:(SDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info;

@end
