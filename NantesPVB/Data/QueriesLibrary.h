//
//  QueriesLibrary.h
//  Parents
//
//  Created by Simon Viaud on 16/04/12.
//  Copyright (c) 2012 DPC Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "NSNull+Protection.h"

@interface QueriesLibrary : NSObject {
	
	sqlite3	*database;
    sqlite3	*olderDatabase;
	BOOL	isLocked;
}

@property (nonatomic) BOOL	isLocked;
@property (nonatomic) sqlite3	*olderDatabase;
@property (nonatomic) sqlite3	*database;

#pragma mark Singleton
+ (QueriesLibrary*)sharedInstance;

#pragma mark Public methods
- (void)createEditableCopyOfDatabaseIfNeeded;
- (BOOL)prepareSQL:(const char *)SQLString statement:(sqlite3_stmt **)statement;
- (BOOL)openDatabase;
- (BOOL)openDatabaseForTransactionnalQueries:(BOOL)transactionnal;
- (BOOL)openDatabaseForLocation;
- (sqlite3_int64)lastInsertRowId;
- (void)closeDatabase;
- (void)closeDatabaseForTransactionnalQueries:(BOOL)transactionnal;

- (BOOL)openOlderVersionOfDatabase;
- (void)closeOlderDatabase;

@end
