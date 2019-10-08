//
//  WSDatas.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/28/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServices.h"
#import <sqlite3.h>
#import "Member.h"
#import "Event.h"

@interface WSDatas : NSObject 

+ (NSMutableArray*)getMembers;
+ (NSMutableArray*)getAppartenances;
+ (NSMutableArray*)getEvents;
+ (BOOL)connectionWithId:(NSString*)idParam andPwd:(NSString*)pwdParam;
+ (NSMutableArray*)getPresencesForEvent:(Event*)eventParam;
+ (NSDictionary*)inscriptionForEvent:(Event*)eventParam subscribe:(BOOL)boolParam;

@end
