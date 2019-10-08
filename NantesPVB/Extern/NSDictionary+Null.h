//
//  NSDictionary+Null.h
//  Parents
//
//  Created by Damien Traille on 18/09/12.
//  Copyright (c) 2012 DPC Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NSNullIfNil(object) (object != nil ? object : [NSNull null])

@interface NSDictionary (Null)

- (NSString*)objectNotNullForKey:(NSString*)key;

@end
