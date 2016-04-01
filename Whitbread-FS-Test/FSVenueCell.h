//
//  FSVenueCell.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSVenueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationName;
@property (weak, nonatomic) IBOutlet UILabel *distanceFromMe;

- (void)styleCell;
- (void)presentCell;

@end
