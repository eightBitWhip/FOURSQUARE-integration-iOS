//
//  FSSearchResultsTable.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultsTableProtocol <NSObject>

- (void)tableRequestedUpdate;

@end

@interface FSSearchResultsTable : UITableView

@property (nonatomic) id<SearchResultsTableProtocol>tableDelegate;

- (void)updateWithResults:(NSDictionary*)results;
- (void)addPTR;
- (void)finishedUpdating;

@end
