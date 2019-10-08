//
//  MemberDao.h
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "QueriesLibrary.h"

@interface MemberDao : NSObject

+ (void)insertMembers:(NSMutableArray*)dictParam;
+ (NSMutableArray*)getMembers;
+ (Member*)getMemberWithId:(NSString*)idParam;
+ (NSMutableArray*)getMembersWithIds:(NSMutableArray*)arrayParam;
+ (NSMutableArray*)getMembersWithTeam:(NSString*)teamParam;

@end
