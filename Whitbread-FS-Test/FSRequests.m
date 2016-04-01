//
//  FSRequests.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSRequests.h"

#import "DataFormatter.h"

@interface FSRequests ()

@property (nonatomic) RequestType requestType;

@end

@implementation FSRequests

- (void)searchNearWithTerm:(NSString *)searchTerm {
    
    self.requestType = kRequestTypeGetLocationsNear;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [self getDataFromAPI:BASE_URL withEndPoint:SEARCH_LOCATION_ENDPOINT andArguments:@{NEAR_ARG_KEY:searchTerm, CLIENT_ID_ARG_KEY:CLIENT_ID_ARG_VAL, CLIENT_SECRET_ARG_KEY:CLIENT_SECRET_ARG_VAL, VERSION_ARG_KEY:VERSION_ARG_VAL}];
        
    });
    
}

#pragma mark - Request Resolution Functions-

- (void)finishedRequestWithData:(NSData *)data {
    
    if( data != nil ) {
        
        NSError *jsonError;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
        
        
        if ( !jsonError ) {
            
            [self handleResponseData:jsonDict];
            
        }
        else [self handleErrorForResponse:nil];
        
    }
    else [self handleErrorForResponse:nil];
    
}

- (void)handleResponseData:(NSDictionary*)response {
    
    switch (self.requestType) {
        case kRequestTypeGetLocationsNear:
            [self searchNearResolutionForResponse:response];
            break;
            
        case kRequestTypePostSomething:
            break;
            
        default:
            break;
    }
    
}

- (void)searchNearResolutionForResponse:(NSDictionary*)responseData {
    
    NSLog(@"response data %@", responseData);
    
    if ( [DataFormatter dictionary:responseData containsAndIsNotNullKey:RESPONSE_RESPONSE_KEY] && [DataFormatter dictionary:[responseData objectForKey:RESPONSE_RESPONSE_KEY] containsAndIsNotNullKey:RESPONSE_VENUES_KEY] ) {
        
        if ( self.searchNearDelegate ) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.searchNearDelegate requestSuccededWithResults:[responseData objectForKey:RESPONSE_RESPONSE_KEY]];
                
            });
            
        }
        
    }
    
}

- (void)handleErrorForResponse:(NSDictionary*)response {
    
    
    
}

- (void)handleErrorWithResponseCode:(int)code {
    
    NSString *errorMessage = nil;
    
    switch (code) {
        case 400:
            errorMessage = @"";
            break;
            
        case 401:
            errorMessage = @"";
            break;
            
        case 403:
            errorMessage = @"";
            break;
            
        case 404:
            errorMessage = @"";
            break;
            
        case 500:
            errorMessage = @"";
            break;
            
        default:
            break;
    }
    
    if ( self.responseDelegate ) {
        [self.responseDelegate requestFailedWithErrorMessage:errorMessage];
    }
    
}

- (void)handleErrorWithNSErrorCode:(int)code {
    
    NSString *errorMessage = nil;
    
    switch (code) {
        case -1001:
            errorMessage = @"";
            break;
            
        case -1005:
            errorMessage = @"";
            break;
            
        case -1009:
            errorMessage = @"";
            break;
            
        case -1012:
            errorMessage = @"";
            break;
            
        default:
            break;
    }
    
    if ( self.responseDelegate ) {
        [self.responseDelegate requestFailedWithErrorMessage:errorMessage];
    }
    
}

@end
