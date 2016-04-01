//
//  FSLocationManager.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSLocationManager : NSObject

+ (FSLocationManager*)sharedManager;

- (float)distanceFromCurrentLocationForLat:(float)lat andLng:(float)lng;

@end
