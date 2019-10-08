//
//  WebServices.m
//  JP3
//
//  Created by Damien Traille on 25/05/11.
//  Copyright 2011 DPC Interactive. All rights reserved.
//

#import "WebServices.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"

@implementation WebServices

static WebServices *webServices;

#pragma mark -
#pragma mark Singleton

+ (WebServices*)sharedInstance {
	
	if(webServices){
		return webServices;
	}
	
	webServices = [[WebServices alloc] init];
	return webServices;
}

- (NSDictionary*)requestWithURL:(NSString*)urlString 
					 postParams:(NSDictionary*)postParams
					  getParams:(NSDictionary*)getParams {
    
    return [self requestWithURL:urlString
                     postParams:postParams
                      getParams:getParams
               progressDelegate:nil];
}

- (NSDictionary*)requestWithURL:(NSString*)urlString 
					 postParams:(NSDictionary*)postParams
					  getParams:(NSDictionary*)getParams
               progressDelegate:(id)progressDelegate {
	
	NSMutableDictionary *returnedDict = [NSMutableDictionary dictionary];
	
	///  - Test Internet Connection
	if ([Reachability reachabilityForInternetConnection] == NotReachable) {
		
		NSLog(@"[WebServices] No internet connection");
		
		return nil;
	}
	
	/// - Build Request
	ASIHTTPRequest *urlRequest = [[ASIHTTPRequest alloc] init];
    [urlRequest setDownloadProgressDelegate:progressDelegate];
    
	NSMutableString *mutableString = [[NSMutableString alloc] initWithString:urlString];
	
#pragma mark /// GET	
	if (getParams && [[getParams allKeys] count] > 0) {
		
		[mutableString appendFormat:@"?"];
		NSInteger cpt = 0;
        
		for (NSString *key in [getParams allKeys]) {
			
			NSObject *paramObject = [getParams objectForKey:key];
			
            if (cpt > 0) {
                [mutableString appendString:@"&"];
            }
            
			// NSString
			if ([paramObject isKindOfClass:[NSString class]]) {
				[mutableString appendFormat:@"%@=%@",key,(NSString*)paramObject];
			}
			// NSNumber
			else if ([paramObject isKindOfClass:[NSNumber class]]) {
				[mutableString appendFormat:@"%@=%i",key,[(NSNumber*)paramObject intValue]];
			}
            
            cpt++;
		}
	}
	
#pragma mark /// POST
	if (postParams && [[postParams allKeys] count] > 0) {
		
		NSMutableData *mutableData = [[NSMutableData alloc] init]; 
		
		for (NSString *key in [postParams allKeys]) {
			
			NSObject *paramObject = [postParams objectForKey:key];
			
			// NSString
			if ([paramObject isKindOfClass:[NSString class]]) {
				[mutableData appendData:[[NSString stringWithFormat:@"%@=%@",key,(NSString*)paramObject] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			// NSNumber
			else if ([paramObject isKindOfClass:[NSNumber class]]) {
				[mutableData appendData:[[NSString stringWithFormat:@"%@=%i",key,[(NSNumber*)paramObject intValue]] dataUsingEncoding:NSUTF8StringEncoding]];
			}
		}
		
		[urlRequest setPostBody:mutableData];
		[mutableData release];
	}
    
	/// - Set URL, timeout and Start Request synchronous
	NSURL *url = [[NSURL alloc] initWithString:[mutableString stringByAddingPercentEscapesUsingEncoding:(NSUTF8StringEncoding)]];
    [urlRequest setRequestMethod:@"GET"];
	[urlRequest setURL:url];
	[urlRequest setTimeOutSeconds:60];
	[urlRequest startSynchronous];
	[mutableString release];
	[url release];
	
    //NSLog(@"url: %@", url);
    
	NSString *error = nil;
	
	if ([urlRequest error]) {
		error = [[NSString alloc] initWithString:[[urlRequest error] localizedDescription]];		
	}
    
	if (error) {
      	NSLog(@"[WebServices] Error : %@",error);
		[returnedDict setObject:error forKey:@"HTTPError"];		
	}
    
	if ([urlRequest responseData]) {
        [returnedDict setObject:[urlRequest responseData] forKey:@"ResponseData"];        
        NSString *responseString = [[NSString alloc] initWithData:[urlRequest responseData] encoding:NSUTF8StringEncoding];
        if (responseString) {
            [returnedDict setObject:responseString forKey:@"ResponseString"];
            [responseString release];
        }
    }
    
	/// - Return dictionnary
	return returnedDict;
}

/* ********
 * TODO : Send image with ASIFormDataRequest
 * ****** */

@end
