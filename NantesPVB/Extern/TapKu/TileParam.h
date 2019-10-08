//
//  TileParam.h
//  Nantes PVB
//
//  Created by Damien Traille on 21/06/13.
//  Copyright (c) 2013 Personnal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TileParam : NSObject {
	NSString		 *backColor;
	NSString		 *day;
	NSArray			 *arrayOfLine;
}

@property (nonatomic, retain) NSString	 *backColor;
@property (nonatomic, retain) NSString	 *day;
@property (nonatomic, retain) NSArray	 *arrayOfLine;

- (id)initWithBackColor:(NSString*)backColorParam
            arrayOfLine:(NSArray*)arrayOfLineParam;

@end
