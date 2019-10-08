//
//  NSDictionary+Null.m
//  Parents
//
//  Created by Damien Traille on 18/09/12.
//  Copyright (c) 2012 DPC Interactive. All rights reserved.
//

#import "NSDictionary+Null.h"

@implementation NSDictionary (Null)

- (NSString*)objectNotNullForKey:(NSString*)key {
  
    NSString *string = [self objectForKey:key];
    
    if (![string isKindOfClass:[NSNull class]] && [string length]>0) {
        return string;
    }

    return @"";
    
}

@end
