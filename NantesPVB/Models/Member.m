//
//  Member.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/27/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "Member.h"

@implementation Member

@synthesize idMember;
@synthesize accord;
@synthesize adresse;
@synthesize codePostal;
@synthesize description;
@synthesize dieuToutPuissant;
@synthesize email;
@synthesize etat;
@synthesize internet;
@synthesize message;
@synthesize nom;
@synthesize passwordMd5;
@synthesize prenom;
@synthesize profession;
@synthesize pseudonyme;
@synthesize sexe;
@synthesize telephones;
@synthesize titre;
@synthesize adhesion;
@synthesize dateNaissance;
@synthesize licenseVolley;
@synthesize premiereAdhesion;
@synthesize urlPhoto;
@synthesize equipe;
@synthesize arrayOfAppartenances;

- (void)dealloc {
    [idMember release];
    [accord release];
    [adresse release];
    [codePostal release];
    [description release];
    [dieuToutPuissant release];
    [email release];
    [etat release];
    [internet release];
    [message release];
    [nom release];
    [passwordMd5 release];
    [prenom release];
    [profession release];
    [pseudonyme release];
    [sexe release];
    [telephones release];
    [titre release];
    [adhesion release];
    [dateNaissance release];
    [licenseVolley release];
    [premiereAdhesion release];
    [urlPhoto release];
    [equipe release];
    [arrayOfAppartenances release];
    [super dealloc];
}

@end
