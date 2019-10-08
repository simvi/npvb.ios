//
//  WSDatas.m
//  Nantes PVB
//
//  Created by Simon Viaud on 8/28/12.
//  Copyright (c) 2012 Personnal. All rights reserved.
//

#import "WSDatas.h"
#import "SBJson.h"
#import "QueriesLibrary.h"
#import "ASIFormDataRequest.h"
#import <NantesPVB-Swift.h>

@implementation WSDatas

+ (NSMutableArray*)getMembers {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"get_members" forKey:@"type"];
    
    NSLog(@"[FLUX] - %@", urlString);

	NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
															   postParams:nil
																getParams:dict];
	[dict release];
    
	NSString *connectionError = [response objectForKey:@"ConnectionError"];
	NSString *httpError = [response objectForKey:@"HTTPError"];
	NSString *responseString = [response objectForKey:@"ResponseString"];
    
    NSLog(@"response: %@", responseString);
    
    NSMutableArray *array = nil;
    
	if (connectionError) {
		NSLog(@"[FLUX] - connectionError %@", httpError);
	} else {
        
        SBJSON *json = [[SBJSON alloc] init];
        
        NSString* hackedString = [responseString stringByReplacingOccurrencesOfString: @"\\'" withString: @"'"];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\15'" withString: @""];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\r" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
        hackedString = [hackedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        array = [json objectWithString:hackedString];
        
        [json release];
    }
    
    return array;
    
}

+ (NSMutableArray*)getAppartenances {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"get_appartenances" forKey:@"type"];
    
	NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
															   postParams:nil
																getParams:dict];
	[dict release];
    
	NSString *connectionError = [response objectForKey:@"ConnectionError"];
	NSString *httpError = [response objectForKey:@"HTTPError"];
	NSString *responseString = [response objectForKey:@"ResponseString"];
    
    NSLog(@"[getAppartenances response]: %@", responseString);
    
    NSMutableArray *responseArray = nil;
    
	if (connectionError) {
		NSLog(@"[FLUX] - connectionError %@", httpError);
	} else {
        
        SBJSON *json = [[SBJSON alloc] init];
        
        NSString* hackedString = [responseString stringByReplacingOccurrencesOfString: @"\\'" withString: @"'"];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\15'" withString: @""];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\r" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
        hackedString = [hackedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        responseArray = [json objectWithString:hackedString];
        
        [json release];
    }
    
    return responseArray;
    
}

+ (NSMutableArray*)getEvents {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    [urlString appendString:@"?type=get_events"];
    
    NSLog(@"[FLUX] - %@", urlString);
    
    NSMutableArray *responseArray = nil;
    
    // Create request
    ASIFormDataRequest *urlRequest = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [urlRequest addRequestHeader:@"User-Agent" value:@"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)"];
    [urlRequest setRequestMethod:@"GET"];
    [urlRequest setTimeOutSeconds:10];
    
    // Start request
    [urlRequest startSynchronous];
    
    // Errors ?
	if ([urlRequest error]) {
      	
        NSLog(@"[FLUX] - getEvents Error : %@", [[urlRequest error] localizedDescription]);
        
		return nil;
	}
    
   // NSLog(@"urlRequest responseString: %@", [urlRequest responseString]);
    
    if ([urlRequest responseString]) {

        SBJsonParser *jsonParser = [SBJsonParser new];
        
        NSString* hackedString = [[urlRequest responseString] stringByReplacingOccurrencesOfString: @"\\'" withString: @"'"];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\15'" withString: @""];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\r" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\n" withString: @" "];
        hackedString = [hackedString stringByReplacingOccurrencesOfString: @"\t" withString: @" "];
        hackedString = [hackedString stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        responseArray = [jsonParser objectWithString:hackedString];

        [jsonParser release];
    
    }
    
//    NSLog(@"[FLUX] - getEvents count: %i", (int)[responseArray count]);
    
    return responseArray;
    
}


/*
 
 
 
 + (NSMutableArray*)getEvents {
 
 NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
 
 NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
 [dict setObject:@"get_events" forKey:@"type"];
 
 NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
 postParams:nil
 getParams:dict];
 [dict release];
 
 NSString *connectionError = [response objectForKey:@"ConnectionError"];
 NSString *httpError = [response objectForKey:@"HTTPError"];
 NSString *responseString = [response objectForKey:@"ResponseString"];
 
 NSLog(@"responseString: %@", responseString);
 
 NSMutableArray *responseArray = nil;
 
 [responseString stringByReplacingOccurrencesOfString:@"\15" withString:@""];
 [responseString stringByReplacingOccurrencesOfString:@"\\15" withString:@""];
 [responseString stringByReplacingOccurrencesOfString:@"null" withString:@""];
 
 if (connectionError) {
 NSLog(@"connectionError %@", httpError);
 } else {
 
 SBJSON *json = [[SBJSON alloc] init];
 
 responseArray = [json objectWithString:[responseString stringByReplacingOccurrencesOfString:@"\\'" withString: @"'"]];
 
 [json release];
 }
 
 NSLog(@"responseArray count: %i", [responseArray count]);
 
 return responseArray;
 
 }
*/


+ (BOOL)connectionWithId:(NSString*)idParam andPwd:(NSString*)pwdParam {
 
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"connection" forKey:@"type"];
    [dict setObject:idParam forKey:@"id"];
    [dict setObject:pwdParam forKey:@"pwd"];
    
	NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
															   postParams:nil
																getParams:dict];
	[dict release];
    
	NSString *connectionError = [response objectForKey:@"ConnectionError"];
	NSString *httpError = [response objectForKey:@"HTTPError"];
	NSString *responseString = [response objectForKey:@"ResponseString"];
    
    NSLog(@"[FLUX] - connectionWithId responseString: %@", responseString);
    
    NSMutableArray *responseArray = nil;
    
    [responseString stringByReplacingOccurrencesOfString:@"\15" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"\\15" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"null" withString:@""];
    [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
    
	if (connectionError) {
		NSLog(@"[FLUX] - connectionError %@", httpError);
	} else {
        
        SBJSON *json = [[SBJSON alloc] init];
        
        responseArray = [json objectWithString:responseString];
        
        [json release];
    }
    
    if (responseArray && [responseArray count]==1) {
        return YES;
    }
    
    return NO;
    
}

+ (NSMutableArray*)getPresencesForEvent:(Event*)eventParam {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"get_presence" forKey:@"type"];
    [dict setObject:[dateFormatter stringFromDate:[eventParam date]] forKey:@"date"];
    
	NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
															   postParams:nil
																getParams:dict];
	[dict release];
    [dateFormatter release];
    
	NSString *connectionError = [response objectForKey:@"ConnectionError"];
	NSString *httpError = [response objectForKey:@"HTTPError"];
	NSString *responseString = [response objectForKey:@"ResponseString"];
    
    NSLog(@"[FLUX] - getPresencesForEvent: %@", responseString);
    
    NSMutableArray *responseArray = nil;
    
	if (connectionError) {
		NSLog(@"[FLUX] - connectionError %@", httpError);
	} else {
    
        [responseString stringByReplacingOccurrencesOfString:@"\15" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"\\15" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"null" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        
        SBJSON *json = [[SBJSON alloc] init];
        
        responseArray = [json objectWithString:responseString];
        
        [json release];
    }
    
    return responseArray;
    
}

+ (NSDictionary*)inscriptionForEvent:(Event*)eventParam subscribe:(BOOL)boolParam {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:kWSNantesPVB];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"inscription" forKey:@"type"];
    [dict setObject:[dateFormatter stringFromDate:[eventParam date]] forKey:@"date"];
    [dict setObject:[[(AppDelegate*)[[UIApplication sharedApplication] delegate] connectedMember] pseudonyme] forKey:@"pseudo"];
    [dict setObject:[eventParam libelle] forKey:@"libelle"];
    
    if (boolParam) {
        [dict setObject:@"o" forKey:@"presence"];
    }
    else {
        [dict setObject:@"n" forKey:@"presence"];
    }

	NSDictionary *response = [[WebServices sharedInstance] requestWithURL:urlString
															   postParams:nil
																getParams:dict];
	[dict release];
    [dateFormatter release];
    
	NSString *connectionError = [response objectForKey:@"ConnectionError"];
	NSString *httpError = [response objectForKey:@"HTTPError"];
	NSString *responseString = [response objectForKey:@"ResponseString"];
    
    NSLog(@"[FLUX] - inscriptionForEvent: %@", responseString);
    
    NSDictionary *responseDict = nil;
    
	if (connectionError) {
		NSLog(@"[FLUX] - connectionError %@", httpError);
	} else {
        
        SBJSON *json = [[SBJSON alloc] init];
        
        [responseString stringByReplacingOccurrencesOfString:@"\15" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"\\15" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"null" withString:@""];
        [responseString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        [responseString stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
        [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@" "];
        
        responseDict = [json objectWithString:responseString];
        
        [json release];
    }
    
    return responseDict;
    
}

@end
