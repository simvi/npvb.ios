//
//  AppartenancesDAO.h
//  Nantes PVB
//
//  Created by Marc Lievremont on 13/05/14.
//  Copyright (c) 2014 Personnal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QueriesLibrary.h"

@interface AppartenancesDAO : NSObject

+ (void)insertAppartenances:(NSMutableArray*)arrayParam;
+ (NSMutableArray*)getAppartenances:(NSString*)stringParam;
+ (NSMutableArray*)getEquipes;

@end
