//
//  InputValidator.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "InputValidator.h"

@implementation InputValidator

+ (BOOL)locationSearchTermIsValid:(NSString *)searchTerm {
    
    if (searchTerm.length >= 3 ) return YES;
    return NO;
    
}

@end
