//
//  EventDao.m
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import "EventDao.h"

@implementation EventDao

+ (void)insertEvents:(NSMutableArray*)arrayParam {
        
    if ([[QueriesLibrary sharedInstance] openDatabaseForTransactionnalQueries:YES]) {
                
        //Delete la table
        NSMutableString *deleteSQL = [NSMutableString string];
        [deleteSQL appendString:@"DELETE FROM events"];
        
        sqlite3_stmt *statement;
        if ([[QueriesLibrary sharedInstance] prepareSQL:[deleteSQL UTF8String] statement:&statement]) {
            int success = sqlite3_step(statement);
            if (success == SQLITE_ERROR) {
                NSLog(@"-ERREUR- Delete Members");
            }
        }
        sqlite3_finalize(statement);

        //on récupére tout les articles
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
        [requeteSQL appendString:@"VALUES (?,?,?,?,?,?,?,?,?,?)"]; // 12 champs
        
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
        
        NSMutableString *requeteSQL = [NSMutableString string];
        [requeteSQL setString:@"SELECT "];
        [requeteSQL appendString:@"COALESCE(date_text,''), "];
        [requeteSQL appendString:@"COALESCE(libelle,''), "];
        [requeteSQL appendString:@"COALESCE(etat,''), "];
        [requeteSQL appendString:@"COALESCE(titre,''), "];
        [requeteSQL appendString:@"COALESCE(intitule,''), "];
        [requeteSQL appendString:@"COALESCE(lieu,''), "];
        [requeteSQL appendString:@"COALESCE(adresse,''), "];
        [requeteSQL appendString:@"COALESCE(adversaire,''), "];
        [requeteSQL appendString:@"COALESCE(domicile,''), "];
        [requeteSQL appendString:@"COALESCE(resultat,''), "];
        [requeteSQL appendString:@"COALESCE(comments,'') "];
        [requeteSQL appendString:@"FROM events "];
        [requeteSQL appendString:@"ORDER BY date_text ASC"];
        
        sqlite3_stmt *statement;
        
        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            
            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                                
                Event *event = [[Event alloc] init];
                [event setIdEvent:i];
                [event setDate:[dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]]];
                [event setLibelle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                [event setEtat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                [event setTitre:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                [event setIntitule:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                [event setLieu:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                [event setAdresse:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                [event setAdversaire:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                [event setDomicile:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                [event setResultat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                [event setComments:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                
                if (![[event etat] isEqualToString:@"A"]) {
                    // si l'event est pas annulé

                    if ([[event titre] hasPrefix:@"NPVB"]) {
                        [event setColor:[UIColor colorWithRed:85.0/255.0 green:170.0/255.0 blue:85.0/255.0 alpha:1.0]];
                    }
                    else if ([[event titre] hasPrefix:@"SEANCE"]) {
                        [event setColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:221.0/255.0 alpha:1.0]];
                    }
                    else if ([[event titre] hasPrefix:@"TOURNOI"]) {
                        [event setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
                    }
                    else if ([[event titre] hasPrefix:@"ASSO"]) {
                        [event setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
                    }
                    
                }
                else {
                    [event setColor:[UIColor colorWithRed:221.0/255.0 green:17.0/255.0 blue:34.0/255.0 alpha:1.0]];
                }
                
                
                [arrayOfEvents addObject:event];
                [event release];
                
                i++;
                
            }
            
            [dateFormatter release];
            
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
 
        
        NSMutableString *requeteSQL = [NSMutableString string];
        [requeteSQL setString:@"SELECT "];
        [requeteSQL appendString:@"COALESCE(date_text,''), "];
        [requeteSQL appendString:@"COALESCE(libelle,''), "];
        [requeteSQL appendString:@"COALESCE(etat,''), "];
        [requeteSQL appendString:@"COALESCE(titre,''), "];
        [requeteSQL appendString:@"COALESCE(intitule,''), "];
        [requeteSQL appendString:@"COALESCE(lieu,''), "];
        [requeteSQL appendString:@"COALESCE(adresse,''), "];
        [requeteSQL appendString:@"COALESCE(adversaire,''), "];
        [requeteSQL appendString:@"COALESCE(domicile,''), "];
        [requeteSQL appendString:@"COALESCE(resultat,''), "];
        [requeteSQL appendString:@"COALESCE(date_text,''), "];
        [requeteSQL appendString:@"COALESCE(comments,'') "];
        [requeteSQL appendString:@"FROM events "];
        [requeteSQL appendFormat:@"WHERE date_text >= '%@' ", [dateFormatter stringFromDate:dateParam]];
        [requeteSQL appendString:@"ORDER BY date_text ASC"];
        
        
        sqlite3_stmt *statement;
        
        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
            

            
            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                Event *event = [[Event alloc] init];
                [event setIdEvent:i];
                [event setDate:[dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]]];
                [event setLibelle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                [event setEtat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                [event setTitre:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                [event setIntitule:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                [event setLieu:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                [event setAdresse:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                [event setAdversaire:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                [event setDomicile:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                [event setResultat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                [event setComments:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                
                if (![[event etat] isEqualToString:@"A"]) {
                    // si l'event est pas annulé
                    
                    if ([[event titre] hasPrefix:@"NPVB"]) {
                        [event setColor:[UIColor colorWithRed:85.0/255.0 green:170.0/255.0 blue:85.0/255.0 alpha:1.0]];
                    }
                    else if ([[event titre] hasPrefix:@"SEANCE"]) {
                        [event setColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:221.0/255.0 alpha:1.0]];
                    }
                    else if ([[event titre] hasPrefix:@"TOURNOI"]) {
                        [event setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
                    }
                    
                }
                else {
                    [event setColor:[UIColor colorWithRed:221.0/255.0 green:17.0/255.0 blue:34.0/255.0 alpha:1.0]];
                }

                
                [arrayOfEvents addObject:event];
                [event release];
                
                i++;
                
            }
            
            [dateFormatter release];
            
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
        
        NSMutableString *requeteSQL = [NSMutableString string];
        [requeteSQL setString:@"SELECT "];
        [requeteSQL appendString:@"COALESCE(date_text,''), "];
        [requeteSQL appendString:@"COALESCE(libelle,''), "];
        [requeteSQL appendString:@"COALESCE(etat,''), "];
        [requeteSQL appendString:@"COALESCE(titre,''), "];
        [requeteSQL appendString:@"COALESCE(intitule,''), "];
        [requeteSQL appendString:@"COALESCE(lieu,''), "];
        [requeteSQL appendString:@"COALESCE(adresse,''), "];
        [requeteSQL appendString:@"COALESCE(adversaire,''), "];
        [requeteSQL appendString:@"COALESCE(domicile,''), "];
        [requeteSQL appendString:@"COALESCE(resultat,''), "];
        [requeteSQL appendString:@"COALESCE(comments,'') "];
        [requeteSQL appendString:@"FROM events "];
        [requeteSQL appendString:@"ORDER BY date ASC"];
        
        // NSLog(@"requeteSQL %@", requeteSQL);
        
        sqlite3_stmt *statement;
        
        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
            
            //NSLog(@"dateParam: %@", [[dateFormatter stringFromDate:dateParam]substringToIndex:8]);
            
            int i = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *eventDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                //NSLog(@"eventDate: %@ ",[eventDate substringToIndex:8]);
                
                if ([[[dateFormatter stringFromDate:dateParam]substringToIndex:8] isEqualToString:[eventDate substringToIndex:8]]) {

                    Event *event = [[Event alloc] init];
                    [event setIdEvent:i];
                    [event setDate:[dateFormatter dateFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]]];
                    [event setLibelle:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
                    [event setEtat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                    [event setTitre:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                    [event setIntitule:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                    [event setLieu:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                    [event setAdresse:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                    [event setAdversaire:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                    [event setDomicile:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                    [event setResultat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                    [event setComments:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                    
                    if (![[event etat] isEqualToString:@"A"]) {
                        // si l'event est pas annulé
                        
                        if ([[event titre] hasPrefix:@"NPVB"]) {
                            [event setColor:[UIColor colorWithRed:85.0/255.0 green:170.0/255.0 blue:85.0/255.0 alpha:1.0]];
                        }
                        else if ([[event titre] hasPrefix:@"SEANCE"]) {
                            [event setColor:[UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:221.0/255.0 alpha:1.0]];
                        }
                        else if ([[event titre] hasPrefix:@"TOURNOI"]) {
                            [event setColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:68.0/255.0 alpha:1.0]];
                        }
                        
                    }
                    else {
                        [event setColor:[UIColor colorWithRed:221.0/255.0 green:17.0/255.0 blue:34.0/255.0 alpha:1.0]];
                    }
                    
                    
                    [arrayOfEvents addObject:event];
                    [event release];
                    
                    i++;

                }
                
                               
            }
            
            [dateFormatter release];
            
        }
        
        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
        
    }
    
    return arrayOfEvents;
    
}


@end
