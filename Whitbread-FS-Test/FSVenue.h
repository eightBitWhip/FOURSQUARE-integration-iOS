//
//  FSVenue.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSVenue : NSObject

@property (nonatomic) NSString *name;

@property (nonatomic) NSURL *url;

@property (nonatomic) NSDictionary *location;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

+ (NSArray*)venuesFromArray:(NSArray*)array;

@end
