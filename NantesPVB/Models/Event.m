//
//  Event.m
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import "Event.h"

@implementation Event

@synthesize idEvent;
@synthesize date;
@synthesize libelle;
@synthesize etat;
@synthesize titre;
@synthesize intitule;
@synthesize lieu;
@synthesize adresse;
@synthesize adversaire;
@synthesize color;
@synthesize comments;

- (void)dealloc {
    [date release];
    [libelle release];
    [etat release];
    [titre release];
    [intitule release];
    [lieu release];
    [adresse release];
    [adversaire release];
    [color release];
    [comments release];
    [super dealloc];
}

@end
