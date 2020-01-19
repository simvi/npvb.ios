//
//  Appartenance.h
//  Nantes PVB
//
//  Created by Olivier Voyer on 19/01/20.
//  Copyright (c) 2012 Olivier Voyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Appartenance : NSObject {

    NSString *joueur;
    NSString *equipe;

}

@property (nonatomic, retain) NSString *joueur;
@property (nonatomic, retain) NSString *equipe;

@end
