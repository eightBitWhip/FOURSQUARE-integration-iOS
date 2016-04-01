//
//  FSRequests.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "AbstractNetworking.h"

@protocol ResponseProtocol <NSObject>

- (void)requestFailedWithErrorMessage:(NSString*)msg;

@end

@protocol SearchRequestProtocol <NSObject>

- (void)requestSuccededWithResults:(NSDictionary*)results;
- (void)requestFailedWithResponse:(NSDictionary*)response;

@end

typedef enum {
    kRequestTypeGetLocationsNear = 0,
    kRequestTypePostSomething = 1,
} RequestType;

@interface FSRequests : AbstractNetworking

@property (nonatomic) id<ResponseProtocol>responseDelegate;
@property (nonatomic) id<SearchRequestProtocol>searchNearDelegate;

- (void)searchNearWithTerm:(NSString*)searchTerm;

@end
