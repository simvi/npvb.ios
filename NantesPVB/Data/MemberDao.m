//
//  MemberDao.m
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import "MemberDao.h"
#import "Member.h"

@interface Member (SQL)

- (instancetype)initWithStatement:(sqlite3_stmt*)statement;
+ (NSMutableString*)SQLSelectFromMembers;
+ (NSMutableString*)SQLDeleteMembers;
+ (NSMutableString*)SQLInsertIntoMembers;

@end

@implementation MemberDao

+ (void)insertMembers:(NSDictionary*)dictParam {

    if ([[QueriesLibrary sharedInstance] openDatabaseForTransactionnalQueries:YES]) {

        sqlite3_stmt *statement;

        if (dictParam) {
            //Delete la table
            NSMutableString *deleteSQL = [Member SQLDeleteMembers];
            if ([[QueriesLibrary sharedInstance] prepareSQL:[deleteSQL UTF8String] statement:&statement]) {
                int success = sqlite3_step(statement);
                if (success == SQLITE_ERROR) {
                    NSLog(@"-ERREUR- Delete Members");
                }
            }
            sqlite3_finalize(statement);
        }

        NSMutableString *requeteSQL = [Member SQLInsertIntoMembers];

        for (NSMutableArray *array in dictParam) {

            if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

                for (NSDictionary *dict in array) {

                    sqlite3_bind_text(statement, 1, [NSNullIfNil([dict objectForKey:@"Accord"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 2, [NSNullIfNil([dict objectForKey:@"Adhesion"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 3, [NSNullIfNil([dict objectForKey:@"Adresse"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 4, [NSNullIfNil([dict objectForKey:@"CPVille"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 5, [NSNullIfNil([dict objectForKey:@"DateNaissance"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 6, [NSNullIfNil([dict objectForKey:@"Description"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 7, [NSNullIfNil([dict objectForKey:@"DieuToutPuissant"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 8, [NSNullIfNil([dict objectForKey:@"Email"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 9, [NSNullIfNil([dict objectForKey:@"Etat"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 10, [NSNullIfNil([dict objectForKey:@"Internet"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 11, [NSNullIfNil([dict objectForKey:@"License"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 12, [NSNullIfNil([dict objectForKey:@"Message"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 13, [NSNullIfNil([dict objectForKey:@"Nom"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 14, [NSNullIfNil([dict objectForKey:@"Password"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 15, [NSNullIfNil([dict objectForKey:@"PremiereAdhesion"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 16, [NSNullIfNil([dict objectForKey:@"Prenom"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 17, [NSNullIfNil([dict objectForKey:@"Profession"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 18, [NSNullIfNil([dict objectForKey:@"Pseudonyme"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 19, [NSNullIfNil([dict objectForKey:@"Sexe"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 20, [NSNullIfNil([dict objectForKey:@"Telephones"]) UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement, 21, [NSNullIfNil([dict objectForKey:@"Titre"]) UTF8String], -1, SQLITE_TRANSIENT);

                    break;
                }

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

+ (NSMutableArray*)getMembers {

    NSMutableArray *arrayOfMembers = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        arrayOfMembers = [NSMutableArray array];

        NSMutableString *requeteSQL = [Member SQLSelectFromMembers];
        [requeteSQL appendString:@"WHERE etat = ? "];
        [requeteSQL appendString:@"ORDER BY prenom ASC"];

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            sqlite3_bind_text(statement, 1, [@"V" UTF8String], -1, SQLITE_TRANSIENT);

            while (sqlite3_step(statement) == SQLITE_ROW) {

                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                if (![name hasPrefix:@"Invité"]) {
                    Member *member = [[Member alloc] initWithStatement:statement];
                    [arrayOfMembers addObject:member];
                    [member release];
                }
            }
        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];

    }

    return arrayOfMembers;
}


+ (Member*)getMemberWithId:(NSString*)idParam {

    Member *member = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        NSMutableString *requeteSQL = [Member SQLSelectFromMembers];
        [requeteSQL appendFormat:@"WHERE pseudonyme = '%@' ", [idParam uppercaseString]];
        [requeteSQL appendFormat:@"OR pseudonyme = '%@' ", [idParam lowercaseString]];

        //NSLog(@"requeteSQL: %@", requeteSQL);

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            if (sqlite3_step(statement) == SQLITE_ROW) {
                member = [[Member alloc] initWithStatement:statement];
            }

        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
    }
    return [member autorelease];
}

+ (NSMutableArray*)getMembersWithIds:(NSMutableArray*)arrayParam {

    NSMutableArray *members = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        NSMutableString *requeteSQL = [Member SQLSelectFromMembers];

        int cpt = 0;
        for (NSString *pseudo in arrayParam) {

            if ([arrayParam count]>1) {
                if (cpt==0) {
                    [requeteSQL appendFormat:@"WHERE pseudonyme = '%@' ", pseudo];
                }
                else {
                    [requeteSQL appendFormat:@"OR pseudonyme = '%@' ", pseudo];
                }
            }
            else if ([arrayParam count]==1) {
                [requeteSQL appendFormat:@"WHERE pseudonyme = '%@' ", pseudo];
            }

            cpt++;
        }

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            members = [NSMutableArray array];

            while (sqlite3_step(statement) == SQLITE_ROW) {
                Member *member = [[Member alloc] initWithStatement:statement];
                [members addObject:member];
                [member release];
            }

        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
    }

    return members;

}


+ (NSMutableArray*)getMembersWithTeam:(NSString*)teamParam {

    NSMutableArray *members = nil;

    if ([[QueriesLibrary sharedInstance] openDatabase]) {

        NSMutableString *requeteSQL = [Member SQLSelectFromMembers];

        if (teamParam!= nil && teamParam.length > 0) {
            [requeteSQL appendString:@"INNER JOIN appartenances ON members.pseudonyme = appartenances.joueur "];
            [requeteSQL appendFormat:@"WHERE appartenances.equipe = '%@' ", teamParam];
            [requeteSQL appendString:@"AND etat = 'V' "];
        }
        else {
            [requeteSQL appendString:@"WHERE etat = 'V' "];
        }

        [requeteSQL appendString:@"ORDER BY prenom ASC"];

        sqlite3_stmt *statement;

        if ([[QueriesLibrary sharedInstance] prepareSQL:[requeteSQL UTF8String] statement:&statement]) {

            members = [NSMutableArray array];

            while (sqlite3_step(statement) == SQLITE_ROW) {
                Member *member = [[Member alloc] initWithStatement:statement];
                [members addObject:member];
                [member release];
            }

        }

        sqlite3_finalize(statement);
        [[QueriesLibrary sharedInstance] closeDatabase];
    }

    return members;

}

@end

@implementation Member (SQL)

- (instancetype)initWithStatement:(sqlite3_stmt*)statement {
    if (self = [super init]) {
        NSString *telephones = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
        NSMutableArray *telArray = nil;

        if ([telephones length]>0) {

            telArray = [NSMutableArray array];

            telephones = [telephones stringByReplacingOccurrencesOfString:@"M" withString:@";"];
            telephones = [telephones stringByReplacingOccurrencesOfString:@"m" withString:@";"];
            telephones = [telephones stringByReplacingOccurrencesOfString:@"d" withString:@";"];
            telephones = [telephones stringByReplacingOccurrencesOfString:@"D" withString:@";"];

            NSArray *tempArray = [telephones componentsSeparatedByString:@";"];

            NSString *prefix = @"33";
            for (NSString *tel in tempArray) {
                if ([tel hasPrefix:prefix]) {
                    tel = [tel substringFromIndex:[prefix length]];
                    tel = [NSString stringWithFormat:@"%i%@", 0,tel];
                }
                if ([tel length]>1) {
                    [telArray addObject:tel];
                }
            }
        }

        [self setAccord:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
        [self setAdhesion:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
        [self setAdresse:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
        [self setCodePostal:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
        [self setDateNaissance:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
        [self setDescription:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
        [self setDieuToutPuissant:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
        [self setEmail:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
        [self setEtat:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
        [self setInternet:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
        [self setLicenseVolley:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
        [self setMessage:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]];
        [self setNom:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)]];
        [self setPasswordMd5:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]];
        [self setPremiereAdhesion:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)]];
        [self setPrenom:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)]];
        [self setProfession:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)]];
        [self setPseudonyme:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)]];
        [self setSexe:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)]];
        [self setTelephones:telArray];
        [self setTitre:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)]];
        [self setUrlPhoto:[NSString stringWithFormat:@"http://nantespvb.free.fr/Photos/Photo%@.jpg", [self pseudonyme]]];
    }
    return self;
}

+ (NSMutableString*)SQLSelectFromMembers {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL setString:@"SELECT "];
    [requeteSQL appendString:@"COALESCE(accord,''), "];
    [requeteSQL appendString:@"COALESCE(adhesion,''), "];
    [requeteSQL appendString:@"COALESCE(adresse,''), "];
    [requeteSQL appendString:@"COALESCE(codePostal,''), "];
    [requeteSQL appendString:@"COALESCE(dateNaissance,''), "];
    [requeteSQL appendString:@"COALESCE(description,''), "];
    [requeteSQL appendString:@"COALESCE(dieuToutPuissant,''), "];
    [requeteSQL appendString:@"COALESCE(email,''), "];
    [requeteSQL appendString:@"COALESCE(etat,''), "];
    [requeteSQL appendString:@"COALESCE(internet,''), "];
    [requeteSQL appendString:@"COALESCE(licenceVolley,''), "];
    [requeteSQL appendString:@"COALESCE(message,''), "];
    [requeteSQL appendString:@"COALESCE(nom,''), "];
    [requeteSQL appendString:@"COALESCE(password,''), "];
    [requeteSQL appendString:@"COALESCE(premiereAdhesion,''), "];
    [requeteSQL appendString:@"COALESCE(prenom,''), "];
    [requeteSQL appendString:@"COALESCE(profession,''), "];
    [requeteSQL appendString:@"COALESCE(pseudonyme,''), "];
    [requeteSQL appendString:@"COALESCE(sexe,''), "];
    [requeteSQL appendString:@"COALESCE(telephones,''), "];
    [requeteSQL appendString:@"COALESCE(titre,'') "];
    [requeteSQL appendString:@"FROM members "];
    return requeteSQL;
}

+ (NSMutableString*)SQLDeleteMembers {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL appendString:@"DELETE FROM members "];
    return requeteSQL;
}

+ (NSMutableString*)SQLInsertIntoMembers {
    NSMutableString *requeteSQL = [NSMutableString string];
    [requeteSQL appendString:@"INSERT OR REPLACE INTO members ("];
    [requeteSQL appendString:@"accord, "];
    [requeteSQL appendString:@"adhesion, "];
    [requeteSQL appendString:@"adresse, "];
    [requeteSQL appendString:@"codePostal, "];
    [requeteSQL appendString:@"dateNaissance, "];
    [requeteSQL appendString:@"description, "];
    [requeteSQL appendString:@"dieuToutPuissant, "];
    [requeteSQL appendString:@"email, "];
    [requeteSQL appendString:@"etat, "];
    [requeteSQL appendString:@"internet, "];
    [requeteSQL appendString:@"licenceVolley, "];
    [requeteSQL appendString:@"message, "];
    [requeteSQL appendString:@"nom, "];
    [requeteSQL appendString:@"password, "];
    [requeteSQL appendString:@"premiereAdhesion, "];
    [requeteSQL appendString:@"prenom, "];
    [requeteSQL appendString:@"profession, "];
    [requeteSQL appendString:@"pseudonyme, "];
    [requeteSQL appendString:@"sexe, "];
    [requeteSQL appendString:@"telephones, "];
    [requeteSQL appendString:@"titre) "];
    [requeteSQL appendString:@"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "]; // 21 champs
    return requeteSQL;
}

@end
