//
//  Appartenance.m
//  Nantes PVB
//
//  Created by Olivier Voyer on 19/01/20.
//  Copyright (c) 2012 Olivier Voyer. All rights reserved.
//

#import "Appartenance.h"

@implementation Appartenance

@synthesize joueur;
@synthesize equipe;

- (void)dealloc {
    [joueur release];
    [equipe release];
    [super dealloc];
}

@end
