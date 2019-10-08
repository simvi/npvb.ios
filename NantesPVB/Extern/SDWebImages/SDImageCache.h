//
//  SDImageCache.h
//  ThePhoneHouseBOA
//
//  Created by Simon on 05/05/11.
//  Copyright 2011 The Phone House. All rights reserved.
//  Developed by Mobile's Republic.
//


#import <UIKit/UIKit.h>
#import "SDImageCacheDelegate.h"

@interface SDImageCache : NSObject
{
    NSMutableDictionary *memCache;
    NSString *diskCachePath;
    NSOperationQueue *cacheInQueue, *cacheOutQueue;
}

+ (SDImageCache *)sharedImageCache;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image imageData:(NSData *)data forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (UIImage *)imageFromKey:(NSString *)key;
- (UIImage *)imageFromKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)queryDiskCacheForKey:(NSString *)key delegate:(id <SDImageCacheDelegate>)delegate userInfo:(NSDictionary *)info;

- (void)removeImageForKey:(NSString *)key;
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;

@end
