//
//  NSNull+Protection.m
//  Hit West
//
//  Created by Luc Plançon on 01/03/13.
//  Copyright (c) 2013 Hit West. All rights reserved.
//  Specified and designed by Groupe Precom
//  Developped by DPC Interactive
//

#import "NSNull+Protection.h"

@implementation NSNull (Protection)

- (int)intValue {
    
    return 0;
    
}

- (float)floatValue {
    
    return 0.0;
    
}

- (double)doubleValue {
    
    return 0.0;
    
}

- (BOOL)boolValue {
    
    return NO;
    
}

- (const char*)UTF8String {
    
    return "";
    
}

- (id)objectAtIndex:(NSUInteger)index {
    
    return [NSNull null];
    
}

- (id)objectForKey:(id)aKey {
    
    return [NSNull null];
    
}

- (BOOL)isEqualToString:(NSString *)aString {
    
    return NO;
    
}

- (NSUInteger)length {
    
    return 0;
    
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    
    return 0;
    
}

- (NSArray *)componentsSeparatedByString:(NSString *)separator {
    
    return [NSArray array];
    
}

- (NSString *)substringToIndex:(NSUInteger)to {
    
    return @"";
    
}

- (NSString*)description {
    
    return @"";
    
}

@end

@implementation NSNumber (Protection)

- (const char*)UTF8String {
    
    return [[NSString stringWithFormat:@"%@", self] UTF8String];
    
}

@end

