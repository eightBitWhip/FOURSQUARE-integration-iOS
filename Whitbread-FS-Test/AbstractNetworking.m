//
//  AbstractNetworking.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "AbstractNetworking.h"

#define DEFAULT_ENCODE_CHARACTERS (@"!*'();:@&=+$,/?%#[]")

#define HTTP_POST (@"POST")
#define HTTP_GET (@"GET")
#define HTTP_DELETE (@"DELETE")
#define HTTP_PUT (@"PUT")

// 4sq doesn't like slash notation!?
#define ATTRIBUTES_SYMBOL (@"?")
#define NEW_ATTRIBUTE_SYMBOL (@"&")
#define EQUALS_SYMBOL (@"=")

#define test_url (@"https://api.foursquare.com/v2/venues/search?near=london&client_id=JOWNR2DUBC5CBXWMYHY4UQXE3PZWMXAOQWCSXOFEYL1ROUTO&client_secret=AKS4LWGOI5P0Q1CZDDC4I1XEORC0BOXWDGKXWNTL4ENAEDEY&v=20130815&limit=10")

@interface AbstractNetworking () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic) NSURLConnection *connection;

@property (nonatomic) NSMutableData *data;

@property (nonatomic) double estimatedResponseSize;

@end

@implementation AbstractNetworking

- (void)getDataFromAPI:(NSString *)baseUrl withEndPoint:(NSString *)endPoint andArguments:(NSDictionary *)args{
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@%@", baseUrl, endPoint, [self getAttributesFromDictionary:args]]];
    [self getRequestWithURL:requestURL];
    
}

- (void)getRequestWithURL:(NSURL*)url {
    
    @try {
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:HTTP_GET];
        
        [self monitoredRequestWithRequest:request];
        
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exeption %@", exception);
        
    }
    
}

- (void)monitoredRequestWithRequest:(NSMutableURLRequest*)request {
    
    self.data = nil;
    self.data = [NSMutableData new];
    
    self.connection = nil;
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.connection start];
    
}

- (void)finishedRequestWithData:(NSData*)data{
    
}

- (void)handleErrorWithResponseCode:(int)code {
    
}

- (void)handleErrorWithNSErrorCode:(int)code {
    
}

- (void)handleResponseData:(NSDictionary*)response {
    
}

- (NSString*)urlEncodedVersion:(NSString *)stringToEncode{
    
    if ( !self.encodeCharacters ) self.encodeCharacters = DEFAULT_ENCODE_CHARACTERS;
    
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)stringToEncode, NULL, (CFStringRef)self.encodeCharacters, kCFStringEncodingUTF8);
    
}

- (NSString*)getAttributesFromDictionary:(NSDictionary*)dictionary{
    
    NSString *attributes = ATTRIBUTES_SYMBOL;
    
    for ( NSString *value in dictionary ) {
        
        attributes = [NSString stringWithFormat:@"%@%@%@%@%@", attributes, value, EQUALS_SYMBOL, [self urlEncodedVersion:[dictionary objectForKey:value]], NEW_ATTRIBUTE_SYMBOL];
        
    }
    
    attributes = [attributes substringToIndex:attributes.length-1];
    return attributes;
    
}

#pragma mark - Connection Delegate Methods-

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    return YES;
    
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
    
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Cancelled authentication challenge");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - Connection Data Delegate Methods-

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    self.estimatedResponseSize = (double)[response expectedContentLength];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if ( !self.data ) {
        self.data = [NSMutableData new];
    }
    
    [self.data appendData:data];
    
    if ( self.estimatedResponseSize ) {
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if ( [error userInfo] ) {
        if ( [[error userInfo] objectForKey:NSUnderlyingErrorKey] ) {
            if ( [[[error userInfo] objectForKey:NSUnderlyingErrorKey] code] ) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self handleErrorWithNSErrorCode:(int)[[[error userInfo] objectForKey:NSUnderlyingErrorKey] code]];
                    
                });
                
            }
        }
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSData *requestData = [NSData dataWithData:self.data];
    
    [self performSelectorOnMainThread:@selector(finishedRequestWithData:) withObject:requestData waitUntilDone:NO];
    
    self.data = nil;
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    
}

@end
