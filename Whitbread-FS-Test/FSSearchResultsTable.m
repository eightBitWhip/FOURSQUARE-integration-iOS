//
//  FSSearchResultsTable.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSSearchResultsTable.h"

#import "DataFormatter.h"

#import "FSVenue.h"

#import "FSVenueCell.h"

#define CELL_REUSE_ID (@"venueCell")

@interface FSSearchResultsTable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *venues;

@end

@implementation FSSearchResultsTable

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
    
}

- (void)updateWithResults:(NSDictionary *)results {
    
    if ( [DataFormatter dictionary:results containsAndIsNotNullKey:RESPONSE_VENUES_KEY] ) {
        
        self.venues = [FSVenue venuesFromArray:[results objectForKey:RESPONSE_VENUES_KEY]];
        [self reloadData];
        
    }
    
}

#pragma mark - TableView DMs-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.venues.count;
    
}

- (NSInteger)numberOfSections {
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self numberOfSections];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSVenueCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_ID forIndexPath:indexPath];
    if ( !cell ) {
        cell = [[FSVenueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_REUSE_ID];
    }
    
    FSVenue *venue = self.venues[indexPath.row];
    cell.locationName.text = venue.name;
    
    [cell styleCell];
    [cell presentCell];
    
    return cell;
    
}

@end
