//
//  AppartenancesDAO.m
//  Nantes PVB
//
//  Created by Marc Lievremont on 13/05/14.
//  Copyright (c) 2014 Personnal. All rights reserved.
//

#import "AppartenancesDAO.h"
#import "QueriesLibrary.h"

@implementation AppartenancesDAO

+ (void)insertAppartenances:(NSMutableArray*)arrayParam {
    
    if ([[QueriesLibrary sharedInstance] openDatabaseForTransactionnalQueries:YES]) {
                
        //Delete la table
        NSMutableString *deleteSQL = [NSMutableString string];
        [deleteSQL appendString:@"DELETE FROM Appartenances"];
        
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
        [requeteSQL appendString:@"INSERT INTO Appartenances ("];
        [requeteSQL appendString:@"joueur, "];
        [requeteSQL appendString:@"equipe) "];
        [requeteSQL appendString:@"VALUES (?,?)"];
        
        for (NSDictionary *dict in arrayParam) {
            
            if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
                
                sqlite3_bind_text(statement, 1, [[dict objectForKey:@"Joueur"] UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(statement, 2, [[dict objectForKey:@"Equipe"] UTF8String], -1, SQLITE_TRANSIENT);
                
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

+ (NSMutableArray*)getAppartenances:(NSString*)stringParam {
    
    NSMutableArray *appartenances = nil;
    
    if ([[QueriesLibrary sharedInstance] openDatabase]) {
        
        NSMutableString *requeteSQL = [NSMutableString string];
        [requeteSQL setString:@"SELECT "];
        [requeteSQL appendString:@"COALESCE(joueur,''), "];
        [requeteSQL appendString:@"COALESCE(equipe,'') "];
        [requeteSQL appendString:@"FROM appartenances "];
        [requeteSQL appendFormat:@"WHERE joueur LIKE '%@'", stringParam];
        
        //NSLog(@"requeteSQL: %@  / %@", requeteSQL, stringParam);
        
        sqlite3_stmt *statement;
        
        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
            
            appartenances = [NSMutableArray array];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                [appartenances addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];

            }
            
        }
        
        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
        
    }
    
    return appartenances;
}

+ (NSMutableArray*)getEquipes {
    
    NSMutableArray *equipes = nil;
    
    if ([[QueriesLibrary sharedInstance] openDatabase]) {
        
        NSMutableString *requeteSQL = [NSMutableString string];
        [requeteSQL setString:@"SELECT "];
        [requeteSQL appendString:@"DISTINCT COALESCE(equipe,'') "];
        [requeteSQL appendString:@"FROM appartenances "];
        [requeteSQL appendString:@"ORDER BY equipe ASC"];
        
        sqlite3_stmt *statement;
        
        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {
            
            equipes = [NSMutableArray array];
            
            [equipes addObject:@"Tous"];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSString *equipe = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                if ([equipe containsString:@"NPVB_U"] || [equipe containsString:@"NPVB_F"] || [equipe containsString:@"NPVB_L"]) {
                    [equipes addObject:equipe];
                }
                
            }
            
        }
        
        sqlite3_finalize(statement);
        
        [[QueriesLibrary sharedInstance] closeDatabase];
        
    }
    
    return equipes;
    
}



@end
