//
//  FSSearchResultsTable.m
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import "FSSearchResultsTable.h"

#import "DataFormatter.h"

#import "FSVenueCell.h"
#import "FSPullToRefresh.h"

#define CELL_REUSE_ID (@"venueCell")

@interface FSSearchResultsTable () <UITableViewDelegate, UITableViewDataSource, PullToRefreshDelegate, UIScrollViewDelegate>

@property (nonatomic) NSArray *venues;

@property (nonatomic) FSPullToRefresh *ptr;

@end

@implementation FSSearchResultsTable

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.alpha = 0.0;
    
    self.backgroundColor = [UIColor clearColor];
    
}

-(void)addPTR{
    
    self.ptr = [[FSPullToRefresh alloc] initWithTableView:self];
    [self.ptr setDelegate:self];
    [self addSubview:self.ptr];
    
}

- (void)updateWithResults:(NSDictionary *)results {
    
    self.alpha = 1.0;
    
    if ( [DataFormatter dictionary:results containsAndIsNotNullKey:RESPONSE_VENUES_KEY] ) {
        
        self.venues = [FSVenue venuesFromArray:[results objectForKey:RESPONSE_VENUES_KEY]];
        [self reloadData];
        
    }
    
    [self finishedUpdating];
    
}

-(void)finishedUpdating{
    
    [self.ptr finishedUpdating];
    
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

#pragma mark - PTRDMs-

-(void)readyForARefreshDontForgetToLetMeKnowWhenYouveFinished{
    
    if ( self.tableDelegate ) {
        [self.tableDelegate tableRequestedUpdate];
    }
        
}

#pragma mark - ScrollView DMs-

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ( self.contentOffset.y < 0 ) {
        [self.ptr updateViewWithOffset:(scrollView.contentOffset.y*-1)];
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.ptr releasedScrollView];
    
}

@end
