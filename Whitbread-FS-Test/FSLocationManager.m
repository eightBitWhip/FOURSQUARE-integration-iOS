//
//  FSLocationManager.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSLocationManager.h"

#import <MapKit/MapKit.h>

static FSLocationManager *sharedInstance = nil;

@interface FSLocationManager () <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) CLLocation *myLocation;

@property (nonatomic) float desiredLat, desiredLng;

@end

@implementation FSLocationManager

+ (FSLocationManager *)sharedManager {
    
    if ( !sharedInstance ){
        sharedInstance = [[FSLocationManager alloc] init];
    }
    
    return sharedInstance;
    
}

- (instancetype)init {
    
    if ( self = [super init] ) {
        
        [self setupLocationMonitoring];
        
    }
    
    return self;
    
}

- (void)setupLocationMonitoring {
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    
    [self checkAuthStatus];
    
    //[self.locationManager startUpdatingLocation];
    
}

- (void)checkAuthStatus {
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ) {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if ( authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
            authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse ) {
            
            [self.locationManager startUpdatingLocation];
            
        }
        else {
            
            [self.locationManager requestWhenInUseAuthorization];
            
        }
        
    }
    
}

- (float)distanceFromCurrentLocationForLat:(float)lat andLng:(float)lng {
    
    if ( self.myLocation ) {
    
        CLLocationCoordinate2D coord = {.latitude = lat,.longitude =  lng};
        CLLocation *compLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        return [self.myLocation distanceFromLocation:compLocation];
        
    }
    
    return -1.0;
    
}

- (void)selectedLocationWithLat:(float)lat andLng:(float)lng {
    
    self.desiredLat = lat, self.desiredLng = lng;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Venue Selected" message:@"How about some directions?" delegate:self cancelButtonTitle:@"No thanks" otherButtonTitles:@"Start route", nil];
    [alert show];
    
}

#pragma mark - Location DMs-

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
        
    if ( [locations count] > 0 ) {
        self.myLocation = [locations lastObject];
        //[self getStoreDistancesForLocation:location];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [self checkAuthStatus];
    
}

#pragma mark - UIAlertView DMs-

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ( [buttonTitle isEqualToString:@"Start route"] ) {
        
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", self.desiredLat, self.desiredLng];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        
    }
    
}

@end
