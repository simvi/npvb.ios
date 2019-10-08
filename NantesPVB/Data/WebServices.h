//
//  WebServices.h
//  JP3
//
//  Created by Damien Traille on 25/05/11.
//  Copyright 2011 DPC Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesConstants.h"

@interface WebServices : NSObject {
    
}

+ (WebServices*)sharedInstance;

- (NSDictionary*)requestWithURL:(NSString*)urlString 
					 postParams:(NSDictionary*)params
					  getParams:(NSDictionary*)params;

- (NSDictionary*)requestWithURL:(NSString*)urlString 
					 postParams:(NSDictionary*)params
					  getParams:(NSDictionary*)params
               progressDelegate:(id)progressDelegate;


@end

