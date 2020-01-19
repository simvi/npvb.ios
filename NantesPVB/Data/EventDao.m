//
//  EventDao.m
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import "EventDao.h"

@interface Event (SQL)

- (instancetype)initWithStatement:(sqlite3_stmt*)statement;
+ (NSMutableString*)SQLSelectFromEvents;
+ (NSMutableString*)SQLDeleteEvents;
+ (NSMutableString*)SQLInsertIntoEvents;

@end

@implementation EventDao

+ (void)insertEvents:(NSMutableArray*)arrayParam {

    if ([[QueriesLibrary sharedInstance] openDatabaseForTransactionnalQueries:YES]) {

        sqlite3_stmt *statement;

        //Delete la table
        NSMutableString *deleteSQL = [Event SQLDeleteEvents];
        if ([[QueriesLibrary sharedInstance] prepareSQL:[deleteSQL UTF8String] statement:&statement]) {
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSLog(@"-ERREUR- Delete Events");
            }
        }
        sqlite3_finalize(statement);

        NSMutableString *requeteSQL = [Event SQLInsertIntoEvents];

        for (NSDictionary *dict in arrayParam) {

            if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

                sqlite3_bind_text(statement, 1, [[dict objectForKey:@"DateHeure"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [[dict objectForKey:@"DateHeureOLD"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 3, [[dict objectForKey:@"Libelle"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 4, [[dict objectForKey:@"Etat"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 5, [[dict objectForKey:@"Titre"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 6, [[dict objectForKey:@"Intitule"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 7, [[dict objectForKey:@"Lieu"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 8, [[dict objectForKey:@"Adresse"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 9, [[dict objectForKey:@"Adversaire"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 10, [[dict objectForKey:@"Analyse"] UTF8String], -1, SQLITE_TRANSIENT);

                int success = sqlite3_step(statement);

                if (success == SQLITE_ERROR) {
                    NSLog(@"Erreur insertion Avis d'expert");
                }
            }
            sqlite3_finalize(statement);
        }
    }
    [[QueriesLibrary sharedInstance] closeDatabaseForTransactionnalQueries:YES];
}

+ (NSMutableArray*)getEvents {

    NSMutableArray *arrayOfEvents = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        arrayOfEvents = [NSMutableArray array];

        NSMutableString *requeteSQL = [Event SQLSelectFromEvents];
        [requeteSQL appendString:@"ORDER BY date_text ASC"];

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {

                Event *event = [[Event alloc] initWithStatement:statement];
                [event setIdEvent:i];
                [arrayOfEvents addObject:event];
                [event release];

                i++;

            }

        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];

    }

    return arrayOfEvents;

}


+ (NSMutableArray*)getEventsFromDate:(NSDate*)dateParam {

    NSMutableArray *arrayOfEvents = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        arrayOfEvents = [NSMutableArray array];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];

        NSMutableString *requeteSQL = [Event SQLSelectFromEvents];
        [requeteSQL appendFormat:@"WHERE date_text >= '%@' ", [dateFormatter stringFromDate:dateParam]];
        [requeteSQL appendString:@"ORDER BY date_text ASC"];

        [dateFormatter release];

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {

                Event *event = [[Event alloc] initWithStatement:statement];
                [event setIdEvent:i];
                [arrayOfEvents addObject:event];
                [event release];

                i++;

            }

        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
    }

    return arrayOfEvents;

}

+ (NSMutableArray*)getEventsForDate:(NSDate*)dateParam {

    NSMutableArray *arrayOfEvents = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        arrayOfEvents = [NSMutableArray array];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];

        NSMutableString *requeteSQL = [Event SQLSelectFromEvents];
        [requeteSQL appendString:@"ORDER BY date ASC"];

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSString *eventDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];

                if ([[[dateFormatter stringFromDate:dateParam]substringToIndex:8] isEqualToString:[eventDate substringToIndex:8]]) {

                    Event *event = [[Event alloc] initWithStatement:statement];
                    [event setIdEvent:i];
                    [arrayOfEvents addObject:event];
                    [event release];

                    i++;

                }

            }

        }
        [dateFormatter release];

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
    }

    return arrayOfEvents;

}

@end

@implementation Event (SQL)

- (instancetype)initWithStatement:(sqlite3_stmt*)statement {
    if (self = [super init]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"] autorelease]];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];

        [self setDate:[dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]]];
        [self setLibelle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
        [self setEtat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
        [self setTitre:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
        [self setIntitule:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
        [self setLieu:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
        [self setAdresse:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
        [self setAdversaire:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
        [self setComments:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];

        if (![[self etat] isEqualToString:@"A"]) {
            // si l'event est pas annulé
            if ([[self titre] hasPrefix:@"NPVB"]) {
                [self setColor:[UIColor colorWithRed:85.0/255.0 green:170.0/255.0 blue:85.0/255.0 alpha:1.0]];
            }
            else if ([[self titre] hasPrefix:@"SEANCE"]) {
                [self setColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:221.0/255.0 alpha:1.0]];
            }
            else if ([[self titre] hasPrefix:@"TOURNOI"]) {
                [self setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
            }
            else if ([[self titre] hasPrefix:@"ASSO"]) {
                [self setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
            }
        }
        else {
            [self setColor:[UIColor colorWithRed:221.0/255.0 green:17.0/255.0 blue:34.0/255.0 alpha:1.0]];
        }

        [dateFormatter release];
    }
    return self;
}

+ (NSMutableString*)SQLSelectFromEvents {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL setString:@"SELECT "];
    [requeteSQL appendString:@"COALESCE(date_text,''), "];
    [requeteSQL appendString:@"COALESCE(date,''), "];
    [requeteSQL appendString:@"COALESCE(libelle,''), "];
    [requeteSQL appendString:@"COALESCE(etat,''), "];
    [requeteSQL appendString:@"COALESCE(titre,''), "];
    [requeteSQL appendString:@"COALESCE(intitule,''), "];
    [requeteSQL appendString:@"COALESCE(lieu,''), "];
    [requeteSQL appendString:@"COALESCE(adresse,''), "];
    [requeteSQL appendString:@"COALESCE(adversaire,''), "];
    [requeteSQL appendString:@"COALESCE(comments,'') "];
    [requeteSQL appendString:@"FROM events "];
    return requeteSQL;
}

+ (NSMutableString*)SQLDeleteEvents {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL appendString:@"DELETE FROM events "];
    return requeteSQL;
}

+ (NSMutableString*)SQLInsertIntoEvents {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL appendString:@"INSERT OR REPLACE INTO events ("];
    [requeteSQL appendString:@"date_text, "];
    [requeteSQL appendString:@"date, "];
    [requeteSQL appendString:@"libelle, "];
    [requeteSQL appendString:@"etat, "];
    [requeteSQL appendString:@"titre, "];
    [requeteSQL appendString:@"intitule, "];
    [requeteSQL appendString:@"lieu, "];
    [requeteSQL appendString:@"adresse, "];
    [requeteSQL appendString:@"adversaire, "];
    [requeteSQL appendString:@"comments) "];
    [requeteSQL appendString:@"VALUES (?,?,?,?,?,?,?,?,?,?)"]; // 10 champs
    return requeteSQL;
}

@end
