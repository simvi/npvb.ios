//
//  NSNull+Protection.h
//  Hit West
//
//  Created by Luc Plançon on 01/03/13.
//  Copyright (c) 2013 Hit West. All rights reserved.
//  Specified and designed by Groupe Precom
//  Developped by DPC Interactive
//

#import <UIKit/UIKit.h>

#define NSNullIfNil(object) (object != nil ? object : [NSNull null])

@interface NSNull (Protection)

- (int)intValue;
- (float)floatValue;
- (double)doubleValue;
- (BOOL)boolValue;
- (const char*)UTF8String;
- (id)objectAtIndex:(NSUInteger)index;
- (id)objectForKey:(id)aKey;
- (BOOL)isEqualToString:(NSString *)aString;
- (NSUInteger)length;
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id*)stackbuf count:(NSUInteger)len;
- (NSArray*)componentsSeparatedByString:(NSString*)separator;
- (NSString*)substringToIndex:(NSUInteger)to;
- (NSString*)description;

@end

@interface NSNumber (Protection)

- (const char*)UTF8String;

@end
