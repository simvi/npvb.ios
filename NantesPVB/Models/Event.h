//
//  Event.h
//  Nantes PVB
//
//  Created by Simon Viaud on 07/11/12.
//  Copyright (c) 2012 Viaud Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Event : NSObject {
    
    NSInteger idEvent;
    NSDate   *date;
    NSString *libelle;
    NSString *etat;
    NSString *titre;
    NSString *intitule;
    NSString *lieu;
    NSString *adresse;
    NSString *adversaire;
    UIColor *color;

}

@property (nonatomic, assign) NSInteger idEvent;
@property (nonatomic, retain) NSDate   *date;
@property (nonatomic, retain) NSString *libelle;
@property (nonatomic, retain) NSString *etat;
@property (nonatomic, retain) NSString *titre;
@property (nonatomic, retain) NSString *intitule;
@property (nonatomic, retain) NSString *lieu;
@property (nonatomic, retain) NSString *adresse;
@property (nonatomic, retain) NSString *adversaire;
@property (nonatomic, retain) UIColor *color;

@end
