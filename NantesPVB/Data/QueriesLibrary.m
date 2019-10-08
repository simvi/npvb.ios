//
//  QueriesLibrary.m
//  Parents
//
//  Created by Simon Viaud on 16/04/12.
//  Copyright (c) 2012 DPC Interactive. All rights reserved.
//

#import "QueriesLibrary.h"

#define kDatabaseNameDefault	  @"npvb.sqlite"
#define kDatabaseName         @"npvb_v1.1.sqlite"

#define DEG2RAD(degrees) (degrees * 0.01745327)

@implementation QueriesLibrary

@synthesize isLocked;
@synthesize database;
@synthesize olderDatabase;

static QueriesLibrary *queriesLib;

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv)
{
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    assert(argc == 4);
    // check that all four arguments are non-null
    if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        sqlite3_result_null(context);
        return;
    }
    // get the four argument values
    double lat1 = sqlite3_value_double(argv[0]);
    double lon1 = sqlite3_value_double(argv[1]);
    double lat2 = sqlite3_value_double(argv[2]);
    double lon2 = sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    
    sqlite3_result_double(context, acos((sin(lat1rad) * sin(lat2rad)) + (cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon1) - DEG2RAD(lon2)))) * 6378.1);
    
}

#pragma mark -
#pragma mark Singleton

+ (QueriesLibrary*)sharedInstance {
	if(queriesLib){
		return queriesLib;
	}
	
	queriesLib = [[QueriesLibrary alloc] init];
	[queriesLib setIsLocked:NO];
	[queriesLib createEditableCopyOfDatabaseIfNeeded];
	
	return queriesLib;
}

#pragma mark -
#pragma mark Public methods

- (void)createEditableCopyOfDatabaseIfNeeded {
	
	while (isLocked) {
		[NSThread sleepForTimeInterval:0.1];
	}
	isLocked = YES;
	BOOL success = NO;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
    
    // Si le dossier Database n'existe pas on le créer
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/Library/Caches/Database/", NSHomeDirectory()]]) {
        NSError *error= nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:[NSString stringWithFormat:@"%@/Library/Caches/Database/", NSHomeDirectory()] withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches/Database/", NSHomeDirectory()];
	
	NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	success = [fileManager fileExistsAtPath:dbPath];
    
	if (success) {
		isLocked = NO;
		return;
	} else {
		
		// Copy the last version	
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseNameDefault];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:[documentsDirectory stringByAppendingPathComponent:kDatabaseName] error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
       
	isLocked = NO;
}


 
- (BOOL)openDatabase {
	
    return [self openDatabaseForTransactionnalQueries:NO];
	
}

- (BOOL)openOlderVersionOfDatabase {
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	BOOL find_older_version = NO;
	BOOL isOpened = NO;
    
	//On cherche si version de la base est présente
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
	while (file = [dirEnum nextObject]) {
                
		if ([file hasSuffix:@".sqlite"]) {
			find_older_version = YES;
            break;
		}		
	}
    
    if (!find_older_version) {
        //pas d'ancienne version de l'appli
        find_older_version = YES;
    }
    else {
        // avait une version < 2.0
        NSString *olderDBPath = [documentsDirectory stringByAppendingPathComponent:file];
        
        if (sqlite3_open([olderDBPath UTF8String], &olderDatabase) == SQLITE_OK) {
            if (sqlite3_exec(olderDatabase, "PRAGMA CACHE_SIZE=50", NULL, NULL, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(olderDatabase));
            }
            isOpened = YES;
        } else {
            NSAssert1(0, @"Failed to open older database with message '%s'.", sqlite3_errmsg(olderDatabase));
        }

    }
    
    return isOpened;
    
}

- (void)closeOlderDatabase {
    sqlite3_close(olderDatabase);
}

- (BOOL)openDatabaseForTransactionnalQueries:(BOOL)transactionnal {
    
    while (isLocked) {
		[NSThread sleepForTimeInterval:0.1];
	}
	isLocked = YES;
	
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches/Database/", NSHomeDirectory()];
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, "PRAGMA CACHE_SIZE=50", NULL, NULL, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(database));
		}
        
        
        if (transactionnal) {
            sqlite3_exec(database, "BEGIN", 0, 0, 0);
        }
        
        sqlite3_create_function(database, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
        
		return YES;
		
	} else {
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
    
}

- (BOOL)openDatabaseForLocation {
    
    while (isLocked) {
		[NSThread sleepForTimeInterval:0.1];
	}
	isLocked = YES;
	
	NSString *documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches/Database/", NSHomeDirectory()];
	NSString *defaultDBPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	
	if (sqlite3_open([defaultDBPath UTF8String], &database) == SQLITE_OK) {
		if (sqlite3_exec(database, "PRAGMA CACHE_SIZE=50", NULL, NULL, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to set cache size with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_create_function(database, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
        
		return YES;
		
	} else {
		NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
    
}

- (sqlite3_int64)lastInsertRowId {
	return sqlite3_last_insert_rowid(database);	
}

- (void)closeDatabase {
	[self closeDatabaseForTransactionnalQueries:NO];    
}

- (void)closeDatabaseForTransactionnalQueries:(BOOL)transactionnal {
    
    if (transactionnal) {
        sqlite3_exec(database, "COMMIT", 0, 0, 0);
    }
    
    sqlite3_close(database);
	isLocked = NO;
    
}

- (BOOL)prepareSQL:(const char *)SQLString statement:(sqlite3_stmt **)statement { 
    
	if (sqlite3_prepare_v2(database, SQLString, -1, statement, NULL) == SQLITE_OK) {
		return YES;
	} else {
		NSAssert1(0, @"Impossible to execute query with message '%s'.", sqlite3_errmsg(database));
		return NO;
	}
}



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
	[super dealloc];
    
}

@end

