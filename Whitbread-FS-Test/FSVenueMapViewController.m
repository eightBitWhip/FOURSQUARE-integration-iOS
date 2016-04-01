//
//  FSVenueMapViewController.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSVenueMapViewController.h"

#import "FSVenue.h"

#import <MapKit/MapKit.h>

@interface FSVenueMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation FSVenueMapViewController

-(void)viewDidAppear:(BOOL)animated {
    
    if ( self.venues ) {
        
        for ( FSVenue *venue in self.venues ) {
            
            /*let newYorkLocation = CLLocationCoordinate2DMake(40.730872, -74.003066)
            // Drop a pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = newYorkLocation
            dropPin.title = "New York City"
            mapView.addAnnotation(dropPin) */
            
            if ( venue.location ) {
            
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[venue.location objectForKey:LOCATION_LAT_KEY] floatValue], [[venue.location objectForKey:LOCATION_LONG_KEY] floatValue]);
                MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
                pin.coordinate = coord;
                pin.title = venue.name;
                [self.map addAnnotation:pin];
            
            }
            
        }
        
    }
    
}

- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
