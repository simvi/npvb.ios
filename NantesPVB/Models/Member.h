//
//  Member.h
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Member : NSObject {
   
    NSString            *idMember;
    NSString            *accord;
    NSString            *adresse;
    NSString            *codePostal;
    NSString            *description;
    NSString            *dieuToutPuissant;
    NSString            *email;
    NSString            *etat;
    NSString            *internet;
    NSString            *message;
    NSString            *nom;
    NSString            *passwordMd5;
    NSString            *prenom;
    NSString            *profession;
    NSString            *pseudonyme;
    NSString            *sexe;
    NSMutableArray      *telephones;
    NSString            *titre;
    NSString            *adhesion;
    NSString            *dateNaissance;
    NSString            *licenseVolley;
    NSString            *premiereAdhesion;
    NSString            *urlPhoto;
    NSString            *equipe;
    NSMutableArray      *arrayOfAppartenances;

}

@property (nonatomic, retain) NSString          *idMember;
@property (nonatomic, retain) NSString          *accord;
@property (nonatomic, retain) NSString          *adresse;
@property (nonatomic, retain) NSString          *codePostal;
@property (nonatomic, retain) NSString          *description;
@property (nonatomic, retain) NSString          *dieuToutPuissant;
@property (nonatomic, retain) NSString          *email;
@property (nonatomic, retain) NSString          *etat;
@property (nonatomic, retain) NSString          *internet;
@property (nonatomic, retain) NSString          *message;
@property (nonatomic, retain) NSString          *nom;
@property (nonatomic, retain) NSString          *passwordMd5;
@property (nonatomic, retain) NSString          *prenom;
@property (nonatomic, retain) NSString          *profession;
@property (nonatomic, retain) NSString          *pseudonyme;
@property (nonatomic, retain) NSString          *sexe;
@property (nonatomic, retain) NSMutableArray    *telephones;
@property (nonatomic, retain) NSString          *titre;
@property (nonatomic, retain) NSString          *adhesion;
@property (nonatomic, retain) NSString          *dateNaissance;
@property (nonatomic, retain) NSString          *licenseVolley;
@property (nonatomic, retain) NSString          *premiereAdhesion;
@property (nonatomic, retain) NSString          *urlPhoto;
@property (nonatomic, retain) NSString          *equipe;
@property (nonatomic, retain) NSMutableArray    *arrayOfAppartenances;

@end
