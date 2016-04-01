//
//  AbstractNetworking.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AbstractNetworking : NSObject

@property (nonatomic) NSString *encodeCharacters;

- (void)getDataFromAPI:(NSString*)baseUrl withEndPoint:(NSString*)endPoint andArguments:(NSDictionary*)args;

@end
