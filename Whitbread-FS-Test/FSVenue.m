//
//  FSVenue.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSVenue.h"

#import "DataFormatter.h"

@implementation FSVenue

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    if ( self = [super init] ) {
        
        if ( [DataFormatter dictionary:dictionary containsAndIsNotNullKey:VENUE_NAME_KEY] ) {
            self.name = [dictionary objectForKey:VENUE_NAME_KEY];
        }
        
        if ( [DataFormatter dictionary:dictionary containsAndIsNotNullKey:VENUE_URL_KEY] ) {
            self.url = [NSURL URLWithString:[dictionary objectForKey:VENUE_URL_KEY]];
        }
        
        if ( [DataFormatter dictionary:dictionary containsAndIsNotNullKey:VENUE_LOCATION_KEY] ) {
            self.location = [dictionary objectForKey:VENUE_LOCATION_KEY];
        }
        
    }
    
    return self;
    
}

+ (NSArray *)venuesFromArray:(NSArray *)array {
    
    NSMutableArray *venues = [NSMutableArray array];
    
    for ( NSDictionary *venueDic in array ) {
        
        FSVenue *venue = [[FSVenue alloc] initWithDictionary:venueDic];
        [venues addObject:venue];
        
    }
    
    return [NSArray arrayWithArray:venues];
    
}

@end
