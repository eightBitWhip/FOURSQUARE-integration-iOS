//
//  DataFormatter.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "DataFormatter.h"

@implementation DataFormatter

+ (BOOL)dictionary:(NSDictionary *)dictionary containsAndIsNotNullKey:(NSString *)key {
    
    if ( [dictionary objectForKey:key] ) {
        
        if ( [dictionary objectForKey:key] != [NSNull null] ) {
            return YES;
        }
        
    }
    
    return NO;
    
}

@end
